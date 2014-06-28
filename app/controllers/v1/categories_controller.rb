class V1::CategoriesController < V1::ApplicationController
  skip_before_action :authenticate, only: [:index]

  # GET /v1/categories
  def index
    @categories = policy_scope(Category)
    render json: @categories
  end
end
