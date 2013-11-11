class ApplicationController < ActionController::Base
  before_filter :load_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

  attr_reader :current_user
  
  # Did the user supply a valid API key?
  def have_valid_api_key?
    @have_valid_api_key
  end

  # Allow the user to log in with a valid API key.  Used with
  # prepend_before_filter.
  def allow_api_key
    @api_key_allowed = true
  end

  # Load the current user if available.
  def load_user
    case
    when session[:user_id]
      @current_user = User.find(session[:user_id]) 
    when @api_key_allowed && token_provided?(params[:api_key])
      @current_user = User.where(api_key: params[:api_key]).first
      @have_valid_api_key = true
    when token_provided?(cookies[:auth_token])
      @current_user = User.where(auth_token: cookies[:auth_token]).first
      # Sign back automatically.
      sign_in_as(@current_user) unless current_user.nil?
    end
  end

  # Does `value` appear to be a real token?  We definitely want to avoid
  # accepting `nil`, which would open security holes.
  def token_provided?(value)
    value.present? && value =~ /\A[A-Fa-f0-9]{32}\z/
  end

  # Call as a before_filter to make sure the user is signed in.
  def authenticate_user!
    unless @current_user
      head :unauthorized
    end
  end

  # Called by our admin dashboard.
  def authenticate_admin_user!
    load_user
    unless @current_user && @current_user.admin?
      redirect_to(root_url)
    end
  end

  # Called by our admin dashboard.
  def current_admin_user
    return current_user if current_user.admin?
    nil
  end

  # Sign in as the specified user.
  def sign_in_as(user, remember_me=false)
    # Always reset session on sign in, as extra protection against session
    # fixation attacks.
    reset_session
    session[:user_id] = user.id
    if remember_me
      user.ensure_auth_token!
      cookies.permanent[:auth_token] = user.auth_token
    end
  end

  # Sign out.
  def sign_out
    cookies.delete(:auth_token)
    reset_session
  end
end
