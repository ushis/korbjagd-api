class V1::PasswordResetsController < V1::ApplicationController
  skip_before_filter :authenticate,      only: [:create]
  skip_after_action  :verify_authorized, only: [:create, :update]

  # POST /v1/password_reset
  def create
    @user = User.find_by_email(email)
    PasswordResetMailJob.new.async.perform(@user) if @user
    render json: {user: {email: email}}
  end

  # PATCH /v1/password_reset
  def update
    if current_user.update_attributes(user_params)
      render json: nil, status: 204
    else
      render_error 422, current_user.errors
    end
  end

  private

  # Returns the current user authenticated by password reset token
  def current_user
    @current_user ||= User.find_by_password_reset_token(auth_token)
  end

  # Returns the permitted user parameters
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Returns the email parameter
  def email
    params.require(:user)[:email]
  end
end
