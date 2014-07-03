class V1::SessionsController < V1::ApplicationController
  skip_before_action :authenticate,      only: [:create]
  skip_after_action  :verify_authorized, only: [:create]

  # POST /v1/sessions
  def create
    @user = User.find_by_email_or_username(user_params[:username])

    if @user.try(:authenticate, user_params[:password])
      render json: @user, root: :user, serializer: SessionSerializer
    else
      unauthorized
    end
  end

  private

  # Returns the required user params
  def user_params
    params.require(:user)
  end
end
