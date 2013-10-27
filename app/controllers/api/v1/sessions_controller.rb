class API::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by(email: session_params[:email])
      .try(:authenticate, session_params[:password])
    if user
      sign_in_as(user, session_params[:remember_me])
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
    params.required(:session).permit(:email, :password, :remember_me)
  end
end
