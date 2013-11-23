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
    translation = EasyTranslate.translate(translate_params[:text], to: 'en')
    json = { translation: translation }
    render json: json
  end

  private

  def translate_params
    params.permit(:text)
  end
end
