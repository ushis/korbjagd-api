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
      before { set_auth_header(token) }

      let!(:user) do
        (action == :create) ? create(:user) : create(:user, :with_avatar)
      end

      let(:send_request) { send method, action, params }

      context 'without token' do
        before { send_request }

        let(:token) { nil }

        let(:params) { nil }

        it { is_expected.to respond_with(401) }
      end

      context 'with invalid token' do
        before { send_request }

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
                image: 'data:something;base64,invalid'
              }
            }
          end

          describe 'response' do
            before { send_request }

            it { is_expected.to respond_with(422) }

            it 'has error details' do
              expect(json['details']['image']).to be_present
            end
          end

          describe 'side effects' do
            it 'does not change the users avatar' do
              expect {
                send_request
              }.to_not change {
                user.reload.avatar
              }
            end
          end
        end

        context 'with a binary file upload' do
          let(:params) do
            {
              avatar: {
                image: fixture_file_upload('sample.png', 'image/png', true)
              }
            }
          end

          describe 'response' do
            before { send_request }

            it { is_expected.to respond_with(422) }

            it 'has error details' do
              expect(json['details']['image']).to be_present
            end
          end

          describe 'side effects' do
            it 'does not change the users avatar' do
              expect {
                send_request
              }.to_not change {
                user.reload.avatar
              }
            end
          end
        end

        context 'with valid params' do
          before { send_request }

          let(:params) do
            {
              avatar: {
                image: base64_png
              }
            }
          end

          let(:avatar) { user.reload.avatar }

          it 'is a success' do
            expect(response).to be_success
          end

          it 'responds with the avatar' do
            expect(json['avatar']).to eq(json_avatar(avatar))
          end

          it 'has the correct extension' do
            expect(File.extname(avatar.image.path)).to eq('.png')
          end

          it 'writes the file to disk' do
            expect(File).to exist(avatar.image.path)
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
        expect(user_with_avatar.reload.avatar).to be_nil
      end
    end
  end
end
