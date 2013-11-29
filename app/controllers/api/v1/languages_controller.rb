class API::V1::LanguagesController < ApplicationController
  respond_to :json
  before_filter :authenticate_supporter!, only: :translate

  def index
    case
    when params[:for_text]
      languages = []
      language = Language.detect(detect_params[:for_text])
      languages << language if language
      respond_with :api, :v1, languages
    else
      respond_with :api, :v1, Language.all
    end
  end

  def translate
    text = translate_params[:text]
    translation = EasyTranslate.translate(text, to: 'en')
    # Note that 'length' counts characters, not bytes, just like the Google
    # APIs. We use semi-raw SQL for this to make it atomic.
    User.where(id: current_user.id)
      .update_all(["characters_translated = characters_translated + ?",
                   text.length])
    # This always comes back with random HTML entities for no good reason.
    # Clean it up.
    coder = HTMLEntities.new
    json = { translation: coder.decode(translation) }
    render json: json
  end

  private

  def detect_params
    params.permit(:for_text)
  end

  def translate_params
    params.permit(:text)
  end
end
