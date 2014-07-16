require 'rails_helper'

describe V1::DeleteTokensController do
  describe 'POST #create' do
    let(:user) { create(:user, password: password) }

    let(:password) { SecureRandom.hex(32) }

    let(:send_request) { post :create, params }

    context 'without token' do
      before { send_request }

      let(:params) { {} }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:params) { {} }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      context 'with invalid password' do
        let(:params) do
          {
            user: {
              password: 'invalid'
            }
          }
        end

        it { is_expected.to respond_with(401) }
      end

      context 'with valid password' do
        let(:params) do
          {
            user: {
              password: password
            }
          }
        end

        it { is_expected.to respond_with(200) }

        it 'responds with the token' do
          expect(json['delete_token']).to eq(json_token(user.delete_token))
        end
      end
    end
  end
end
