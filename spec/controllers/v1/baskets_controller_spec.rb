require 'rails_helper'

describe V1::BasketsController do
  describe 'GET #index' do
    let(:baskets) { create_list(:basket, 10) }

    let(:sector) { baskets.first.sector }

    before { get :index, {sector_id: sector_id} }

    context 'invalid sector_id' do
      let(:sector_id) { -1 }

      it { is_expected.to respond_with(404) }
    end

    context 'valid sector_id' do
      let(:sector_id) { sector.id }

      it { is_expected.to respond_with(200) }

      it 'has at least one basket' do
        expect(json['baskets']).to_not be_empty
      end

      it 'responds with the sectors baskets' do
        expect(json['baskets']).to eq(json_baskets(sector.baskets))
      end
    end
  end

  describe 'GET #show' do
    let(:basket) { create(:basket) }

    before { get :show, {id: id} }

    context 'invalid id' do
      let(:id) { 0 }

      it { is_expected.to respond_with(404) }
    end

    context 'valid id' do
      let(:id) { basket.id }

      it { is_expected.to respond_with(200) }

      it 'responds with the basket' do
        expect(json['basket']).to eq(json_basket(basket))
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

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

      context 'with invalid params' do
        before { send_request }

        context 'with missing name' do
          let(:params) do
            {
              basket: {
                latitude: build(:point).latitude,
                longitude: build(:point).longitude
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']['name']).to be_present
          end
        end

        context 'invalid latitude' do
          let(:params) do
            {
              basket: {
                latitude: 111.11,
                longitude: build(:point).longitude,
                name: SecureRandom.hex(32)
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']['latitude']).to be_present
          end
        end

        context 'invalid longitude' do
          let(:params) do
            {
              basket: {
                latitude: build(:point).latitude,
                longitude: -191.9,
                name: SecureRandom.hex(32)
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']['longitude']).to be_present
          end
        end
      end

      context 'with valid params' do
        let(:params) do
          {
            basket: {
              latitude: build(:point).latitude,
              longitude: build(:point).longitude,
              name: SecureRandom.hex(32)
            }
          }
        end

        describe 'response' do
          before { send_request }

          it { is_expected.to respond_with(201) }

          it 'responds with the new basket' do
            expect(json['basket']).to \
              eq(json_basket(Basket.find(json['basket']['id'])))
          end

          it 'has the posted latitude' do
            expect(json['basket']['latitude']).to \
              eq(params[:basket][:latitude])
          end

          it 'has the posted longitude' do
            expect(json['basket']['longitude']).to \
              eq(params[:basket][:longitude])
          end

          it 'has the posted name' do
            expect(json['basket']['name']).to eq(params[:basket][:name])
          end

          it 'belongs to the current user' do
            expect(json['basket']['user']).to eq(json_user(user))
          end
        end

        describe 'side effects' do
          it 'creates a basket' do
            expect { send_request }.to change { Basket.count }.by(1)
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    let(:basket) { create(:basket, user: user) }

    let(:foreign_basket) { create(:basket) }

    let(:send_request) { patch :update, params }

    context 'without token' do
      before { send_request }

      let(:params) { {id: basket.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:params) { {id: basket.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      context 'user does not own the basket' do
        before { send_request }

        let(:params) { {id: foreign_basket.id} }

        it { is_expected.to respond_with(403) }
      end

      context 'user owns the basket' do
        let(:params) { {id: basket.id}.merge(patch_params) }

        context 'with invalid params' do
          before { send_request }

          let(:patch_params) do
            {
              basket: {
                name: ''
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']['name']).to be_present
          end
        end

        context 'with valid params' do
          let(:patch_params) do
            {
              basket: {
                name: SecureRandom.hex(12),
                # filtered params
                latitude: build(:point).latitude,
                longitude: build(:point).longitude
              }
            }
          end

          describe 'response' do
            before { send_request }

            it { is_expected.to respond_with(200) }

            it 'responds with the basket' do
              expect(json['basket']).to eq(json_basket(basket.reload))
            end
          end

          describe 'side effects' do
            it 'changes the name' do
              expect {
                send_request
              }.to change {
                basket.reload.name
              }.to(patch_params[:basket][:name])
            end

            it 'does not change the latitude' do
              expect { send_request }.to_not change { basket.reload.latitude }
            end

            it 'does not change the longitude' do
              expect { send_request }.to_not change { basket.reload.longitude }
            end
          end
        end
      end

      context 'the basket has no owner' do
        before { foreign_basket.user.destroy }

        let(:params) do
          {
            id: foreign_basket.id,
            basket: {
              name: SecureRandom.hex(12)
            }
          }
        end

        describe 'response' do
          before { send_request }

          it { is_expected.to respond_with(200) }

          it 'responds with the basket' do
            expect(json['basket']).to eq(json_basket(foreign_basket.reload))
          end
        end

        describe 'side effects' do
          it 'changes the owner' do
            expect {
              send_request
            }.to change {
              foreign_basket.reload.user
            }.from(nil).to(user)
          end

          it 'changes the name' do
            expect {
              send_request
            }.to change {
              foreign_basket.reload.name
            }.to(params[:basket][:name])
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    let(:basket) { create(:basket, user: user) }

    let(:foreign_basket) { create(:basket) }

    let(:send_request) { delete :destroy, {id: id} }

    context 'without token' do
      before { send_request }

      let(:id) { basket.id }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:id) { basket.id }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      context 'user does not own the basket' do
        let(:id) { foreign_basket.id }

        it { is_expected.to respond_with(403) }

        it 'does not destroy the basket' do
          expect { foreign_basket.reload }.to_not raise_error
        end
      end

      context 'user owns the basket' do
        let(:id) { basket.id }

        it { is_expected.to respond_with(204) }

        it 'destroys the basket' do
          expect { basket.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
