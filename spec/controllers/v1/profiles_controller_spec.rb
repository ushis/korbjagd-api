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
      let(:params) { nil }

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

  describe 'PATCH #update' do
    let!(:user) { create(:user, password: password) }

    let(:password) { SecureRandom.hex(16) }

    let(:send_request) { patch :update, params }

    context 'without token' do
      before { send_request }

      let(:params) { nil }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      let(:params) { nil }

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(401) }
      end

      describe 'side effects' do
        it 'does not change the user' do
          expect { send_request }.to_not change { user.updated_at }
        end
      end
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      context 'without password_current' do
        let(:params) do
          {
            user: {
              email: 'harry@example.com'
            }
          }
        end

        describe 'response' do
          before { send_request }

          it { is_expected.to respond_with(401) }
        end

        describe 'side effects' do
          it 'does not change the user' do
            expect { send_request }.to_not change { user.updated_at }
          end
        end
      end

      context 'with invalid password_current' do
        let(:params) do
          {
            user: {
              email: 'harry@example.com',
              password_current: 'invalid'
            }
          }
        end

        describe 'response' do
          before { send_request }

          it { is_expected.to respond_with(401) }
        end

        describe 'side effects' do
          it 'does not change the user' do
            expect { send_request }.to_not change { user.reload.updated_at }
          end
        end
      end

      context 'with valid password_current' do
        context 'with invalid params' do
          let!(:other_user) { create(:user) }

          context 'with duplicate email' do
            let(:params) do
              {
                user: {
                  email: other_user.email,
                  password_current: password
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
              it 'does not change the user' do
                expect { send_request }.to_not change { user.reload.updated_at }
              end
            end
          end

          context 'with invalid password_confirmation' do
            let(:params) do
              {
                user: {
                  email: other_user.email,
                  password: 'secret',
                  password_confirmation: 'seCret',
                  password_current: password
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
              it 'does not change the user' do
                expect { send_request }.to_not change { user.reload.updated_at }
              end
            end
          end
        end

        context 'with valid params' do
          let(:params) do
            {
              user: {
                email: "#{SecureRandom.hex(16)}@example.com",
                notifications_enabled: false,
                password_current: password,
                # filtered params
                username: 'harry',
                admin: true,
                baskets_count: 44
              }
            }
          end

          describe 'response' do
            before { send_request }

            it { is_expected.to respond_with(200) }

            it 'responds with the users profile' do
              expect(json['user']).to eq(json_profile(user.reload))
            end
          end

          describe 'side effects' do
            it 'does change the users update_at attribute' do
              expect { send_request }.to change { user.reload.updated_at }
            end

            it 'does not change the users username' do
              expect { send_request }.to_not change { user.reload.username }
            end

            it 'changes the users email' do
              expect {
                send_request
              }.to change {
                user.reload.email
              }.to(params[:user][:email])
            end

            it 'changes the users notifications_enabled attribute' do
              expect {
                send_request
              }.to change {
                user.reload.notifications_enabled
              }.to(params[:user][:notifications_enabled])
            end

            it 'does not change the users admin prvileges' do
              expect { send_request }.to_not change { user.reload.admin }
            end

            it 'does not change the users baskets_count' do
              expect {
                send_request
              }.to_not change {
                user.reload.baskets_count
              }
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    let(:send_request) { delete :destroy }

    describe 'without token' do
      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(401) }
      end

      describe 'side effects' do
        it 'does not delete a user' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    describe 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(401) }
      end

      describe 'side effects' do
        it 'does not delete a user' do
          expect { send_request }.to_not change { User.count }
        end
      end
    end

    describe 'with valid token' do
      before { set_auth_header(user.auth_token) }

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(204) }
      end

      describe 'side effects' do
        it 'does delete a user' do
          expect { send_request }.to change { User.count }.by(-1)
        end

        it 'does delete the user' do
          expect {
            send_request
          }.to change {
            User.where(id: user.id).count
          }.from(1).to(0)
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
