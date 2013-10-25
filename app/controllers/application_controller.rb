class ApplicationController < ActionController::Base
  before_filter :load_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  attr_reader :current_user

  # Used to determine when we can bypass verify_authenticity_token.
  def have_api_key?
    params[:api_key].present?
  end

  # Invoked via prepend_before_filter for methods we can call via the API.
  def load_user_from_api_key
    if params[:api_key]
      @current_user ||= User.where(api_key: params[:api_key]).first
    end
  end

  # Load the current user if available.
  def load_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id]) 
    end
  end

  # Call as a before_filter to make sure the user is signed in.
  def authenticate_user!
    unless @current_user
      head :unauthorized
    end
  end

  # Sign in as the specified user.
  def sign_in_as(user)
    # Always reset session on sign in, as extra protection against session
    # fixation attacks.
    reset_session
    session[:user_id] = user.id
  end

  # Sign out.
  def sign_out
    reset_session
  end
end
