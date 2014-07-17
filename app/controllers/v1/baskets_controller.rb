class V1::BasketsController < V1::ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :find_sector, only: [:index]
  before_action :find_basket, only: [:show, :update, :destroy]

  # GET /v1/sectors/:sector_id/baskets
  def index
    if stale?(@sector, public: true)
      @baskets = policy_scope(@sector.baskets)
      render json: {baskets: @baskets.pluck_h(:id, :latitude, :longitude)}
    end
  end

  # GET /v1/baskets/:id
  def show
    fresh_when(@basket, public: true)
    render json: @basket
  end

  # POST /v1/baskets
  def create
    @basket = @current_user.baskets.new(basket_params)
    authorize @basket

    if @basket.save
      NewBasketMailJob.new.async.perform(@basket)
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

  # Finds the requested sector
  def find_sector
    @sector = Sector.find(params[:sector_id])
  end

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
end
