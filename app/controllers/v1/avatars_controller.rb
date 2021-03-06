class V1::AvatarsController < V1::ApplicationController
  before_action :find_user
  before_action :find_avatar,  only: [:create, :update]
  before_action :find_avatar!, only: [:show, :destroy]

  # GET /v1/profile/avatar
  def show
    if stale?(@avatar, public: false)
      render json: @avatar
    end
  end

  # POST /v1/profile/avatar
  def create
    if @avatar.update_attributes(avatar_params)
      render json: @avatar, status: 201
    else
      render_error 422, @avatar.errors
    end
  end

  # PATCH /v1/profile/avatar
  def update
    if @avatar.update_attributes(avatar_params)
      render json: @avatar
    else
      render_error 422, @avatar.errors
    end
  end

  # DELETE /v1/users/:user_id/avatar
  def destroy
    if @avatar.destroy
      head 204
    else
      render_error 422, @avatar.errors
    end
  end

  private

  # Finds the requested user
  def find_user
    @user = current_user
  end

  # Finds the requested avatar
  def find_avatar
    @avatar = @user.avatar || @user.build_avatar
    authorize @avatar
  end

  # Finds the requested avatar
  #
  # Raises ActiveRecord::RecordNotFound on error
  def find_avatar!
    @avatar = @user.avatar!
    authorize @avatar
  end

  # Returns the permitted avatar params
  def avatar_params
    params
      .require(:avatar)
      .permit(*policy(@avatar).permitted_attributes)
  end
end
