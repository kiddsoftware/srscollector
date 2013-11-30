class API::V1::PlayableMediaController < ApplicationController
  before_filter :authenticate_supporter!

  respond_to :json

  def index
    respond_with :api, :v1, user_playable_media
  end

  private

  # Limit ourselves to the cards associated with this user.
  def user_playable_media
    current_user.playable_media
  end
end
