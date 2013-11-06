class API::V1::CardModelsController < ApplicationController
  respond_to :json

  def index
    respond_with CardModel.all.includes(:card_model_fields)
  end

  def show
    respond_with CardModel.find(params[:id])
  end
end
