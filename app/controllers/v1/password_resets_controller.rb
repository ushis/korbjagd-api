class V1::PasswordResetsController < V1::ApplicationController
  skip_before_filter :authenticate,      only: [:create]
  skip_after_action  :verify_authorized, only: [:create]

  # POST /v1/password_reset
  def create
    @user = User.find_by_email(user_params[:email])
    PasswordResetMailJob.new.async.perform(@user) if @user
    render json: {user: {email: user_params[:email]}}
  end

  private

  # Returns the required user params
  def user_params
    params.require(:user)
  end
end
