class V1::DeleteTokensController < V1::ApplicationController
  skip_after_action :verify_authorized, only: [:create]

  # POST /profile/delete_token
  def create
    if current_user.authenticate(password)
      render json: {delete_token: {token: current_user.delete_token}}
    else
      unauthorized
    end
  end

  private

  # Returns the :password parameter
  def password
    params.require(:user).try(:fetch, :password, nil)
  end
end
