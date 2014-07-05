class V1::UsersController < V1::ApplicationController
  skip_before_action :authenticate, only: [:show, :create]

  before_action :find_user, only: [:show, :update, :destroy]

  # GET /v1/users
  def index
    @users = policy_scope(User).includes(:avatar)
    render json: @users, each_serializer: ProfileSerializer
  end

  # GET /v1/users/:id
  def show
    render json: @user, root: :user, serializer: policy(@user).serializer
  end

  # POST /v1/users
  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      WelcomeMailJob.new.async.perform(@user)
      render json: @user, status: 201, root: :user, serializer: ProfileSerializer
    else
      render_error 422, @user.errors
    end
  end

  # PATCH /v1/users/:id
  def update
    if @user.update_attributes(user_params)
      render json: @user, root: :user, serializer: ProfileSerializer
    else
      render_error 422, @user.errors
    end
  end

  # DELETE /v1/users/:id
  def destroy
    if @user.destroy
      render json: nil, status: 201
    else
      render_error 422, @user.errors
    end
  end

  private

  # Finds the requested user
  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

  # Returns the permitted user parameters
  def user_params
    params
      .require(:user)
      .permit(*policy(@user || User.new).permitted_attributes)
  end
end
