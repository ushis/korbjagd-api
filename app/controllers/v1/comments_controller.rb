class V1::CommentsController < V1::ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :find_basket
  before_action :find_comment, only: [:show, :update, :destroy]

  # GET /v1/baskets/:basket_id/comments
  def index
    @comments = policy_scope(@basket.comments).includes(user: :avatar)

    if stale?(@comments, public: true)
      render json: @comments
    end
  end

  # GET /v1/baskets/:basket_id/comments/:id
  def show
    if stale?(@comment, last_modified: @comment.last_modified, public: true)
      render json: @comment
    end
  end

  # POST /v1/baskets/:basket_id/comments
  def create
    @comment = @basket.comments.new(comment_params.merge(user: @current_user))
    authorize @comment

    if @comment.save
      NewCommentMailJob.new.async.perform(@comment)
      render json: @comment, status: 201
    else
      render_error 422, @comment.errors
    end
  end

  # PATCH /v1/baskets/:basket_id/comments/:id
  def update
    if @comment.update_attributes(comment_params)
      render json: @comment
    else
      render_error 422, @comment.errors
    end
  end

  # DELETE /v1/baskets/:basket_id/comments/:id
  def destroy
    if @comment.destroy
      render json: nil, status: 204
    else
      render_error 422, @comment.errors
    end
  end

  private

  # Finds the requested basket
  def find_basket
    @basket = Basket.find(params[:basket_id])
  end

  # Finds the requested comment
  def find_comment
    @comment = @basket.comments.find(params[:id])
    authorize @comment
  end

  # Returns the permitted comment parameters
  def comment_params
    params
      .require(:comment)
      .permit(*policy(@comment || Comment.new).permitted_attributes)
  end
end
