require 'rails_helper'

describe V1::ProfilesController do
  describe 'GET #show' do
    let!(:user) { create(:user) }

    context 'without token' do
      before { get :show }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { get :show }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { get :show }

      it { is_expected.to respond_with(200) }

      it 'responds with the users profile' do
        expect(json['user']).to eq(json_profile(user))
      end
    end
  end

  describe 'POST #create' do
    let!(:existing_user) { create(:user) }

    let(:send_request) { post :create, params }

    context 'without params' do
      let(:params) { {} }

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(422) }
      end

      describe 'side effects' do
        it 'does not change he number of users' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    context 'with missing params' do
      let(:params) { {user: {something: 'something'}} }

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(422) }

        it 'has error details' do
          %w(username email password).each do |attr|
            expect(json['details'][attr]).to be_present
          end
        end
      end

      describe 'side effects' do
        it 'does not change he number of users' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    context 'with incorrect password confirmation' do
      let(:params) do
        {
          user: {
            username: 'harry',
            email: 'harry@example.com',
            password: 'secret',
            password_confirmation: 'secRet'
          }
        }
      end

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(422) }

        it 'has error details' do
          expect(json['details']['password_confirmation']).to be_present
        end
      end

      describe 'side effects' do
        it 'does not change he number of users' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    context 'with duplicate username' do
        let(:params) do
          {
            user: {
              username: existing_user.username,
              email: 'harry@example.com',
              password: 'secret',
              password_confirmation: 'secret'
            }
          }
        end

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(422) }

        it 'has error details' do
          expect(json['details']['username']).to be_present
        end
      end

      describe 'side effects' do
        it 'does not change he number of users' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    context 'with duplicate email' do
      let(:params) do
        {
          user: {
            username: 'harry',
            email: existing_user.email,
            password: 'secret',
            password_confirmation: 'secret'
          }
        }
      end

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(422) }

        it 'has error details' do
          expect(json['details']['email']).to be_present
        end
      end

      describe 'side effects' do
        it 'does not change he number of users' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    context 'with valid params' do
      let(:params) do
        {
          user: {
            username: 'harry',
            email: 'harry@example.com',
            password: 'secret',
            password_confirmation: 'secret',
            # filtered params
            admin: true,
            baskets_count: 10
          }
        }
      end

      describe 'response' do
        before { send_request }

        let(:user) { User.find(json['user']['id']) }

        it { is_expected.to respond_with(201) }

        it 'responds with the profile of the created user' do
          expect(json['user']).to eq(json_profile(user))
        end

        it 'creates a user with correct username and email' do
          %i(username email).each do |attr|
            expect(user.send(attr)).to eq(params[:user][attr])
          end
        end

        it 'creates a user without admin privileges' do
          expect(user.admin).to be false
        end

        it 'creates a user with notifications enabled' do
          expect(user.notifications_enabled).to be true
        end

        it 'creates a user with baskets_count 0' do
          expect(user.baskets_count).to eq(0)
        end
      end

      describe 'side effects' do
        it 'changes the number of users' do
          expect { send_request }.to change { User.count }.by(1)
        end

        it 'sends an email' do
          expect {
            send_request
          }.to change {
            ActionMailer::Base.deliveries.length
          }.by(1)
        end
      end
    end
  end
end
