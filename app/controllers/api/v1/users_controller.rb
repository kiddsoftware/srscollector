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

  protected

  def user_params
    params.required(:user).permit(:email, :password, :password_confirmation)
  end
end
