require 'rails_helper'

describe V1::CommentsController do
  describe 'GET #index' do
    let(:basket) { create(:basket) }

    let!(:comments) { create_list(:comment, 4, basket: basket) }

    let(:send_request) { get :index, {basket_id: basket_id} }

    context 'with invalid basket_id' do
      let(:basket_id) { 0 }

      before { send_request }

      it { is_expected.to respond_with(404) }
    end

    context 'with valid basket_id' do
      let(:basket_id) { basket.id }

      before { send_request }

      it { is_expected.to respond_with(200) }

      it 'responds with the baskets comments' do
        expect(json['comments']).to match_array(json_comments(comments))
      end
    end
  end

  describe 'GET #show' do
    let(:comment) { create(:comment) }

    before { get :show, params }

    context 'with invalid basket_id' do
      let(:params) { {basket_id: 0, id: comment.id} }

      it { is_expected.to respond_with(404) }
    end

    context 'with invalid comment id' do
      let(:params) { {basket_id: comment.basket.id, id: 0} }

      it { is_expected.to respond_with(404) }
    end

    context 'with valid ids' do
      let(:params) { {basket_id: comment.basket.id, id: comment.id} }

      it { is_expected.to respond_with(200) }

      it 'responds with the comment' do
        expect(json['comment']).to eq(json_comment(comment))
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    let(:basket) { create(:basket, user: user) }

    let(:send_request) { post :create, params }

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

      before { send_request }

      context 'with invalid basket_id' do
        let(:params) { {basket_id: 0} }

        it { is_expected.to respond_with(404) }
      end

      context 'with valid basket_id' do
        let(:params) { {basket_id: basket.id}.merge(post_params) }

        context 'with invalid params' do
          let(:post_params) do
            {
              comment: {
                comment: ''
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has errror details' do
            expect(json['details']['comment']).to be_present
          end
        end

        context 'with valid params' do
          let(:post_params) do
            {
              comment: {
                comment: SecureRandom.hex(32)
              }
            }
          end

          it { is_expected.to respond_with(201) }

          it 'responds with the comment' do
            expect(json['comment']).to eq(json_comment(basket.comments.last))
          end

          it 'has the postet comment' do
            expect(json['comment']['comment']).to \
              eq(post_params[:comment][:comment])
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    let(:comment) { create(:comment, user: user) }

    let(:foreign_comment) { create(:comment) }

    let(:send_request) { patch :update, params }

    context 'without token' do
      before { send_request }

      let(:params) { {basket_id: comment.basket.id, id: comment.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:params) { {basket_id: comment.basket.id, id: comment.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      context 'user does not own comment' do
        let(:params) do
          {basket_id: foreign_comment.basket.id, id: foreign_comment.id}
        end

        it { is_expected.to respond_with(403) }
      end

      context 'user owns the comment' do
        let(:params) do
          {basket_id: comment.basket.id, id: comment.id}.merge(patch_params)
        end

        context 'with invalid params' do
          let(:patch_params) do
            {
              comment: {
                comment: nil
              }
            }
          end

          it { is_expected.to respond_with(422) }

          it 'has error details' do
            expect(json['details']['comment']).to be_present
          end
        end

        context 'with valid params' do
          let(:patch_params) do
            {
              comment: {
                comment: SecureRandom.hex(32)
              }
            }
          end

          it { is_expected.to respond_with(200) }

          it 'responds with the comment' do
            expect(json['comment']).to eq(json_comment(comment.reload))
          end

          it 'updates the comment' do
            expect(comment.reload.comment).to \
              eq(patch_params[:comment][:comment])
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    let(:comment) { create(:comment, user: user) }

    let(:foreign_comment) { create(:comment) }

    let(:send_request) { delete :destroy, params }

    context 'without token' do
      before { send_request }

      let(:params) { {basket_id: comment.basket.id, id: comment.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with invalid token' do
      before { set_auth_header(user.password_reset_token) }

      before { send_request }

      let(:params) { {basket_id: comment.basket.id, id: comment.id} }

      it { is_expected.to respond_with(401) }
    end

    context 'with valid token' do
      before { set_auth_header(user.auth_token) }

      before { send_request }

      context 'user does not own the comment' do
        let(:params) do
          {basket_id: foreign_comment.basket.id, id: foreign_comment.id}
        end

        it { is_expected.to respond_with(403) }

        it 'does not destroy the comment' do
          expect { comment.reload }.to_not raise_error
        end
      end

      context 'user owns the comment' do
        let(:params) { {basket_id: comment.basket.id, id: comment.id} }

        it { is_expected.to respond_with(204) }

        it 'destroys the comment' do
          expect {
            comment.reload
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
