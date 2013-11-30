class API::V1::SubtitlesController < ApplicationController
  before_filter :authenticate_supporter!
  
  respond_to :json

  def index
    respond_with :api, :v1, user_playable_media_subtitles
  end

  private

  def user_playable_media_subtitles
    id = params.permit(:playable_media_id)
    current_user.playable_media(id: id).first.subtitles
  end
end
