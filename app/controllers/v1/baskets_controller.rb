class V1::BasketsController < V1::ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :find_basket, only: [:show, :update, :destroy]

  # GET /v1/baskets
  def index
    @baskets = policy_scope(Basket).in_bounds(bounds)

    render json: @baskets,
      each_serializer: BasketsSerializer,
      meta_key: :params,
      meta: {bounds: bounds}
  end

  # GET /v1/baskets/:id
  def show
    render json: @basket
  end

  # POST /v1/baskets
  def create
    @basket = @current_user.baskets.new(basket_params)
    authorize @basket

    if @basket.save
      render json: @basket, status: 201
    else
      render_error 422, @basket.errors
    end
  end

  # PATCH /v1/baskets/:id
  def update
    @basket.user ||= current_user

    if @basket.update_attributes(basket_params)
      render json: @basket
    else
      render_error 422, @basket.errors
    end
  end

  # DELETE /v1/baskets/:id
  def destroy
    if @basket.destroy
      render json: nil, status: 204
    else
      render_error 422, @basket.errors
    end
  end

  private

  # Finds the requested basket
  def find_basket
    @basket = Basket.find(params[:id])
    authorize @basket
  end

  # Returns the permitted basket parameters
  def basket_params
    params
      .require(:basket)
      .permit(*policy(@basket || Basket.new).permitted_attributes)
  end

  # Returns the bounds calculated from the :bounds parameter
  def bounds
    @bounds ||= Bounds.build(*Point.parse_all(params[:bounds]))
  end
end
