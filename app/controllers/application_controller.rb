class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  attr_reader :current_user

  # Call as a before_filter to make sure the user is signed in.
  def authenticate_user!
    if session[:user_id]
      @current_user ||= User.find(session[:user_id]) 
    end
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
