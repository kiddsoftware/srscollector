class API::V1::SubtitlesController < ApplicationController
  before_filter :authenticate_supporter!
  
  respond_to :json

  def index
    respond_with :api, :v1, user_playable_media_subtitles
  end

  private

  def user_playable_media_subtitles
    id = params.permit(:playable_media_id)[:playable_media_id]
    media = current_user.playable_media.where(id: id).first!
    media.subtitles
  end
end
