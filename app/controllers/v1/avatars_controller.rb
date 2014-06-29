class V1::AvatarsController < V1::ApplicationController
  skip_before_action :authenticate, only: [:show]

  before_action :find_user
  before_action :find_avatar

  # GET /v1/users/:user_id/avatar
  def show
    render json: @avatar
  end

  # POST /v1/users/:user_id/avatar
  def create
    if @avatar.update_attributes(avatar_params)
      render json: @avatar, status: 201
    else
      render_error 422, @avatar.errors
    end
  end

  # PATCH /v1/users/:user_id/avatar
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
      render json: nil, status: 204
    else
      render_error 422, @avatar.errors
    end
  end

  private

  # Finds the requested user
  def find_user
    @user = User.find(params[:user_id])
  end

  # Finds the requested avatar
  def find_avatar
    @avatar = @user.avatar
    authorize @avatar
  end

  # Returns the permitted avatar params
  def avatar_params
    params
      .require(:avatar)
      .permit(*policy(@avatar).permitted_attributes)
  end
end
