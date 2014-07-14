require 'rails_helper'

describe V1::SessionsController do
  describe 'POST #create' do
    let!(:user) { create(:user, password: password) }

    let(:password) { SecureRandom.hex(32) }

    before { post :create, params }

    context 'without params' do
      let(:params) { nil }

      it { is_expected.to respond_with(422) }
    end

    context 'with invalid username' do
      let(:params) do
        {
          user: {
            username: 'invalid',
            password: password
          }
        }
      end

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid password' do
      let(:params) do
        {
          user: {
            username: user.username,
            password: 'invalid'
          }
        }
      end

      it { is_expected.to respond_with(401) }
    end

    context 'with correct credentials' do
      let(:params) do
        {
          user: {
            username: user.username,
            password: password
          }
        }
      end

      it { is_expected.to respond_with(200) }

      it 'responds with the user session' do
        expect(json['user']).to eq(json_session(user))
      end
    end
  end
end
