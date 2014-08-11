require 'rails_helper'

describe V1::PhotosController do
  describe 'GET #show' do
    let(:basket) { create(:basket) }

    let(:basket_with_photo) { create(:basket, :with_photo) }

    before { get :show, params }

    context 'with invalid basket_id' do
      let(:params) { {basket_id: 0} }

      it { is_expected.to respond_with(404) }
    end

    context 'basket without photo' do
      let(:params) { {basket_id: basket.id} }

      it { is_expected.to respond_with(404) }
    end

    context 'basket with photo' do
      let(:params) { {basket_id: basket_with_photo.id} }

      it { is_expected.to respond_with(200) }

      it 'responds with the photo' do
        expect(json['photo']).to eq(json_photo(basket_with_photo.photo))
      end
    end
  end

  [[:post, :create], [:patch, :update]].each do |method, action|
    describe "#{method} ##{action}" do
      let(:user) { create(:user) }

      let(:basket) do
        if action == :create
          create(:basket, user: user)
        else
          create(:basket, :with_photo, user: user)
        end
      end

      let(:foreign_basket) do
       (action == :create) ? create(:basket) : create(:basket, :with_photo)
      end

      let(:send_request) { send method, action, params }

      context 'without token' do
        let(:params) { {basket_id: basket.id} }

        before { send_request }

        it { is_expected.to respond_with(401) }
      end

      context 'with invalid token' do
        let(:params) { {basket_id: basket.id} }

        before { set_auth_header(user.password_reset_token) }

        before { send_request }

        it { is_expected.to respond_with(401) }
      end

      context 'with valid token' do
        before { set_auth_header(user.auth_token) }

        context 'with invalid basket_id' do
          before { send_request }

          let(:params) { {basket_id: 0} }

          it { is_expected.to respond_with(404) }
        end

        context 'with valid basket_id' do
          context 'user is not basket owner' do
            let(:params) { {basket_id: foreign_basket.id} }

            describe 'response' do
              before { send_request }

              it { is_expected.to respond_with(403) }
            end

            describe 'side effects' do
              it 'does not change the baskets photo' do
                expect {
                  send_request
                }.to_not change {
                  foreign_basket.reload.photo
                }
              end
            end
          end

          context 'user is basket owner' do
            let(:params) { post_params.merge({basket_id: basket.id}) }

            context 'with invalid params' do
              let(:post_params) do
                {
                  photo: {
                    image: 'invalid'
                  }
                }
              end

              describe 'response' do
                before { send_request }

                it { is_expected.to respond_with(422) }

                it 'contains error details' do
                  expect(json['details']['image']).to be_present
                end
              end

              describe 'side effects' do
                it 'does not change the baskets photo' do
                  expect {
                    send_request
                  }.to_not change {
                    basket.reload.photo
                  }
                end
              end
            end

            context 'with a binary file upload' do
              let(:post_params) do
                {
                  photo: {
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
                it 'does not change the baskets photo' do
                  expect {
                    send_request
                  }.to_not change {
                    basket.reload.photo
                  }
                end
              end
            end

            context 'with valid params' do
              before { send_request }

              let(:post_params) do
                {
                  photo: {
                    image: base64_png
                  }
                }
              end

              let(:photo) { basket.reload.photo }

              it 'is a success' do
                expect(response).to be_success
              end

              it 'responds with the photo' do
                expect(json['photo']).to eq(json_photo(photo))
              end

              it 'has the correct extension' do
                expect(File.extname(photo.image.path)).to eq('.png')
              end

              it 'writes the file to disk' do
                expect(File).to exist(photo.image.path)
              end
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    let(:basket) { create(:basket, user: user) }

    let(:basket_with_photo) { create(:basket, :with_photo, user: user) }

    let(:foreign_basket) { create(:basket, :with_photo) }

    let(:send_request) { delete :destroy, {basket_id: basket_id} }

    context 'without token' do
      let(:basket_id) { basket.id }

      before { send_request }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:basket_id) { basket.id }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      context 'with invalid basket id' do
        let(:basket_id) { 0 }

        it { is_expected.to respond_with(404) }
      end

      context 'user is not the basket owner' do
        let(:basket_id) { foreign_basket.id }

        it { is_expected.to respond_with(403) }
      end

      context 'user is the basket owner' do
        context 'basket has no photo' do
          let(:basket_id) { basket.id }

          it { is_expected.to respond_with(404) }
        end

        context 'basket has a photo' do
          let(:basket_id) { basket_with_photo.id }

          it { is_expected.to respond_with(204) }

          it 'deletes the photo' do
            expect(basket_with_photo.reload.photo).to be_nil
          end
        end
      end
    end
  end
end
