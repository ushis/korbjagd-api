class V1::PhotosController < V1::ApplicationController
  skip_before_action :authenticate, only: [:show]

  before_action :find_basket
  before_action :find_photo,  only: [:create, :update]
  before_action :find_photo!, only: [:show, :destroy]

  # GET /v1/baskets/:basket_id/photo
  def show
    if stale?(@photo, last_modified: @photo.last_modified, public: true)
      render json: @photo
    end
  end

  # POST /v1/baskets/:basket_id/photo
  def create
    if @photo.update_attributes(photo_params.merge(user: current_user))
      render json: @photo, status: 201
    else
      render_error 422, @photo.errors
    end
  end

  # PATCH /v1/baskets/:basket_id/photo
  def update
    if @photo.update_attributes(photo_params.merge(user: current_user))
      render json: @photo
    else
      render_error 422, @photo.errors
    end
  end

  # DELETE /v1/baskets/:basket_id/photo
  def destroy
    if @photo.destroy
      head 204
    else
      render_error 422, @photo.errors
    end
  end

  private

  # Finds the requested basket
  def find_basket
    @basket = Basket.find(params[:basket_id])
  end

  # Finds the requested photo
  def find_photo
    @photo = @basket.photo || @basket.build_photo
    authorize @photo
  end

  # Finds the requested photo
  #
  # Raises ActiveRecord::RecordNotFound on error
  def find_photo!
    @photo = @basket.photo!
    authorize @photo
  end

  # Returns the permitted photo parameters
  def photo_params
    params
      .require(:photo)
      .permit(*policy(@photo).permitted_attributes)
  end
end
