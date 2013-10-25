class API::V1::UsersController < ApplicationController
  # Let external programs fetch the API successfully.  We don't need to
  # protect this route anyway, since it's safe for anyone to trigger as
  # long as they don't get access to the results (and even then, they'd
  # need full credentials to do anything).
  skip_before_filter :verify_authenticity_token, only: :api_key

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
