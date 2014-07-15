require 'rails_helper'

describe V1::AvatarsController do
  describe 'GET #show' do
    let!(:user) { create(:user) }

    let!(:user_with_avatar) { create(:user, :with_avatar) }

    before { set_auth_header(token) }

    before { get :show }

    context 'without token' do
      let(:token) { nil }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      let(:token) { user.password_reset_token }

      it { is_expected.to respond_with(401) }
    end

    context 'without avatar' do
      let(:token) { user.auth_token }

      it { is_expected.to respond_with(404) }
    end

    context 'with avatar' do
      let(:token) { user_with_avatar.auth_token }

      it { is_expected.to respond_with(200) }

      it 'responds with avatar' do
        expect(json['avatar']).to eq(json_avatar(user_with_avatar.avatar))
      end
    end
  end

  [[:post, :create], [:patch, :update]].each do |method, action|
    describe "#{method} ##{action}" do
      let!(:user) { create(:user) }

      before { set_auth_header(token) }

      before { send method, action, params }

      context 'without token' do
        let(:token) { nil }

        let(:params) { nil }

        it { is_expected.to respond_with(401) }
      end

      context 'with invalid token' do
        let(:token) { user.password_reset_token }

        let(:params) { nil }

        it { is_expected.to respond_with(401) }
      end

      context 'with valid token' do
        let(:token) { user.auth_token }

        context 'with invalid params' do
          let(:params) do
            {
              avatar: {
                image: 'invalid'
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']).to be_present
          end
        end

        context 'with valid params' do
          let(:params) do
            {
              avatar: {
                image: base64_png
              }
            }
          end

          it 'is a success' do
            expect(response).to be_success
          end

          it 'responds with the avatar' do
            expect(json['avatar']).to eq(json_avatar(user.avatar))
          end

          it 'has the correct extension' do
            expect(File.extname(user.avatar.image.path)).to eq('.png')
          end

          it 'writes the file to disk' do
            expect(File).to exist(user.avatar.image.path)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    let!(:user_with_avatar) { create(:user, :with_avatar) }

    before { set_auth_header(token) }

    before { delete :destroy }

    context 'without token' do
      let(:token) { nil }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      let(:token) { user.password_reset_token }

      it { is_expected.to respond_with(401) }
    end

    context 'without avatar' do
      let(:token) { user.auth_token }

      it { is_expected.to respond_with(404) }
    end

    context 'with avatar' do
      let(:token) { user_with_avatar.auth_token }

      it { is_expected.to respond_with(204) }

      it 'deletes the users avatar' do
        expect(user.avatar).to be_nil
      end
    end
  end
end
