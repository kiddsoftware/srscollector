class API::V1::UsersController < ApplicationController
  respond_to :json

  def create
    user = User.create(user_params)
    login_as(user) if user.valid?
    respond_with :api, :v1, user
  end

  protected

  def user_params
    params.required(:user).permit(:email, :password, :password_confirmation)
  end
end
