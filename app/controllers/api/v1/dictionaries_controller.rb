class API::V1::DictionariesController < ApplicationController
  respond_to :json

  def index
    respond_with Dictionary.all
  end
end
