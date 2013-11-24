class API::V1::LanguagesController < ApplicationController
  respond_to :json
  before_filter :authenticate_supporter!, only: :translate

  def detect
    json = { preferred: http_accept_language.user_preferred_languages }
    if params[:text]
      detected = CLD.detect_language(params[:text])
      json[:text] = detected[:code]
    end
    render json: json
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

  def translate_params
    params.permit(:text)
  end
end
