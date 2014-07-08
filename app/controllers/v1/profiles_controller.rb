class V1::ProfilesController < V1::ApplicationController
  before_action :authorize

  # GET /v1/profile
  def show
    render json: current_user, root: :user, serializer: ProfileSerializer
  end

  # PATCH /v1/profile
  def update
    if current_user.update_attributes(user_params)
      render json: current_user, root: :user, serializer: ProfileSerializer
    else
      render_error 422, current_user.errors
    end
  end

  # DELETE /v1/profile
  def destroy
    if current_user.destroy
      GoodbyeMailJob.new.async.perform(current_user)
      render json: nil, status: 204
    else
      render_error 422, current_user.errors
    end
  end

  private

  # Returns the permitted user parameters
  def user_params
    params
      .require(:user)
      .permit(*policy(current_user).permitted_attributes)
  end

  # Authorizes an action on the current user
  def authorize
    super(current_user)
  end
end
