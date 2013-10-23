class API::V1::UsersController < ApplicationController
  # This API is web-only because I want signups to go through the web for
  # now.  Talk to me if you have a use-case for this.
  before_filter :web_only_api

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
