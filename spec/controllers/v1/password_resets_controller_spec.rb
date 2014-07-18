require 'rails_helper'

describe V1::PasswordResetsController do
  describe 'POST #create' do
    let!(:user) { create(:user) }

    let(:send_request) { post :create, params }

    context 'with invalid params' do
      before { send_request }

      let(:params) { {} }

      it { is_expected.to respond_with(422) }
    end

    context 'with invalid email' do
      let(:params) do
        {
          user: {
            email: 'invalid@example.com'
          }
        }
      end

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(200) }

        it 'responds with the posted email' do
          expect(json['user']['email']).to eq(params[:user][:email])
        end
      end

      describe 'side effects' do
        it 'sends an email' do
          expect {
            send_request
          }.to_not change {
            ActionMailer::Base.deliveries.length
          }
        end
      end
    end

    context 'with valid email' do
      let(:params) do
        {
          user: {
            email: user.email
          }
        }
      end

      describe 'response' do
        before { send_request }

        it { is_expected.to respond_with(200) }

        it 'responds with the posted email' do
          expect(json['user']['email']).to eq(params[:user][:email])
        end
      end

      describe 'side effects' do
        it 'sends an email' do
          expect {
            send_request
          }.to change {
            ActionMailer::Base.deliveries.length
          }.by(1)
        end
      end

      describe 'mail' do
        before { send_request }

        subject { ActionMailer::Base.deliveries.last }

        it 'has the correct recipient' do
          expect(subject.to).to match_array([user.email])
        end

        let(:token) do
          subject.body.raw_source.scan(/https?:\/\/[^\s]+\/([^\s\/]+)/)[0][0]
        end

        it 'includes the password reset token' do
          expect(PasswordResetToken.from_s(token).id).to eq(user.id)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    let(:send_request) { patch :update, params }

    context 'without token' do
      before { send_request }

      let(:params) { {} }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      let(:params) { {} }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      context 'with invalid params' do
        let(:params) do
          {
            user: {
              password: 'secret',
              password_confirmation: 'seCret'
            }
          }
        end

        it { is_expected.to respond_with(422) }

        it 'has error details' do
          expect(json['details']['password_confirmation']).to be_present
        end
      end

      context 'with valid params' do
        let(:params) do
          {
            user: {
              password: 'secret',
              password_confirmation: 'secret'
            }
          }
        end

        it { is_expected.to respond_with(204) }

        it 'updates the users password' do
          expect(user.reload.authenticate(params[:user][:password])).to eq(user)
        end
      end
    end
  end
end
