class API::V1::DictionariesController < ApplicationController
  before_filter :web_only_api

  respond_to :json

  def index
    respond_with Dictionary.all
  end
end
