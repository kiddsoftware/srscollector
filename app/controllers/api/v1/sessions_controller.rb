class API::V1::SessionsController < ApplicationController
  # This API is web-only because we'll use either API keys or OAuth2 to
  # authenticate external clients, and not require users to had out their
  # emails and passwords.
  before_filter :web_only_api

  respond_to :json

  def create
    user = User.find_by(email: session_params[:email])
      .try(:authenticate, session_params[:password])
    if user
      sign_in_as(user) 
      render json: { user: user, csrf_token: form_authenticity_token }
    else
      head :unauthorized
    end
  end

  def destroy
    sign_out
    head :no_content
  end

  def session_params
    params.required(:session).permit(:email, :password)
  end
end
