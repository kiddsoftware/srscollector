class API::V1::PlayableMediaController < ApplicationController
  before_filter :authenticate_supporter!

  respond_to :json

  def index
    respond_with :api, :v1, user_playable_media
  end

  def show
    respond_with :api, :v1, user_playable_media.find(params.permit(:id)[:id])   
  end

  def create
    respond_with :api, :v1, user_playable_media.create(playable_media_params)
  end

  private

  # Parameters which the user may pass in for PlayableMedia objects.
  def playable_media_params
    params.required(:playable_media).
      permit(:url, :title, :language_id, subtitles_urls: [])
  end

  # Limit ourselves to the cards associated with this user.
  def user_playable_media
    current_user.playable_media
  end
end
