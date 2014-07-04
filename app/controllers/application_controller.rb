class ApplicationController < ActionController::API
  include Pundit

  rescue_from Pundit::NotAuthorizedError,         with: :forbidden
  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::ParameterMissing, with: :unprocessable_entity

  before_action :authenticate
  before_action :add_cors_headers

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  skip_before_action :authenticate,      only: :options
  skip_after_action  :verify_authorized, only: :options

  # Handles all OPTIONS requests
  def options
    headers['Access-Control-Max-Age'] = '1728000'
    render json: nil, status: 204
  end

  private

  # Adds cors headers to the response
  def add_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE'
    headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
  end

  # Renders a error response
  def render_error(status, errors={})
    msg = Rack::Utils::HTTP_STATUS_CODES[status]
    render json: { error: msg, details: errors }, status: status
  end

  # Renders a 401 error
  def unauthorized
    response.headers['WWW-Authenticate'] = 'Bearer realm="API"'
    render_error 401
  end

  # Renders a 403 error
  def forbidden
    render_error 403
  end

  # Renders a 404 error
  def not_found
    render_error 404
  end

  # Renders a 422 error
  def unprocessable_entity
    render_error 422
  end

  # Returns the current user or nil, if this is an anonymous request.
  def current_user
    @current_user ||= User.find_by_auth_token(auth_token)
  end

  # Ensures that the request is done by an authenticated user
  def authenticate
    unauthorized if current_user.nil?
  end

  # Returns the requests auth token
  def auth_token
    request.headers['Authorization'].to_s.split.last
  end
end
