class API::V1::UsersController < ApplicationController
  respond_to :json

  def create
    user = User.create(user_params)
    if user.valid?
      sign_in_as(user) 
      render json: { user: user, csrf_token: form_authenticity_token }
    else
      respond_with :api, :v1, user
    end
  end

  # DANGER! Not yet final. Use at your own risk.
  def api_key
    user = User.find_by(email: user_params[:email])
      .try(:authenticate, user_params[:password])
    if user
      user.ensure_api_key!
      render json: { user: { api_key: user.api_key } }
    else
      head :unauthorized
    end
  end

  protected

  def user_params
    params.required(:user).permit(:email, :password, :password_confirmation)
  end
end
