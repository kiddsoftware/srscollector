class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def sign_in_as(user)
    # Always reset session on sign in, as extra protection against session
    # fixation attacks.
    reset_session
    session[:user_id] = user.id
  end

  def sign_out
    reset_session
  end
end
