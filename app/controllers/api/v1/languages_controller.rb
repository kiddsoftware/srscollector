class API::V1::LanguagesController < ApplicationController
  respond_to :json

  def detect
    json = { preferred: http_accept_language.user_preferred_languages }
    if params[:text]
      detected = CLD.detect_language(params[:text])
      json[:text] = detected[:code]
    end
    respond_with(json, status: :ok, location: nil)
  end
end
