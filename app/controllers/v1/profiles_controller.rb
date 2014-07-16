class V1::ProfilesController < V1::ApplicationController
  skip_before_action :authenticate, only: [:create]

  before_action :find_user, only: [:show, :update, :destroy]

  # GET /v1/profile
  def show
    render json: @user, root: :user, serializer: ProfileSerializer
  end

  # POST /v1/profile
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

  # PATCH /v1/profile
  def update
    if !@user.authenticate(password)
      unauthorized
    elsif @user.update_attributes(user_params)
      render json: @user, root: :user, serializer: ProfileSerializer
    else
      render_error 422, @user.errors
    end
  end

  # DELETE /v1/profile
  def destroy
    if @user.destroy
      GoodbyeMailJob.new.async.perform(@user)
      render json: nil, status: 204
    else
      render_error 422, @user.errors
    end
  end

  private

  # Finds the current user
  def find_user
    @user = current_user
    authorize @user
  end

  # Returns the permitted user parameters
  def user_params
    params
      .require(:user)
      .permit(*policy(@user || User.new).permitted_attributes)
  end

  # Returns the :password_current parameter
  def password
    params.require(:user).try(:fetch, :password_current, nil)
  end

  # Returns the current user authenticated by delete token on :destroy requests
  def current_user
    @current_user ||= if params[:action] == 'destroy'
      User.find_by_delete_token(token)
    else
      super
    end
  end
end
