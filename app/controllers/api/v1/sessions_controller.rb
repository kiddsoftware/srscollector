class API::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by(email: session_params[:email])
      .try(:authenticate, session_params[:password])
    if user
      sign_in_as(user) 
      respond_with :api, :v1, user
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
