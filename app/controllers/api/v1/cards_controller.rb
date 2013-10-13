class API::V1::CardsController < ApplicationController
  respond_to :json

  def index
    respond_with :api, :v1, Card.all
  end

  def show
    respond_with :api, :v1, Card.find(params[:id])
  end

  def create
    respond_with :api, :v1, Card.create(card_params)
  end

  def update
    respond_with :api, :v1, Card.update(params[:id], card_params)
  end

  def destroy
    respond_with :api, :v1, Card.destroy(params[:id])
  end

  protected

  # Specify legal parameters using the new Rails 4 "Strong Parameters."
  def card_params
    params.required(:card).permit(:state, :front, :back, :source, :source_url)
  end
end
