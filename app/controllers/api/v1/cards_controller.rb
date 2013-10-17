class API::V1::CardsController < ApplicationController
  respond_to :json
  respond_to :csv, only: :index

  def index
    query = Card.all
    query = query.where(state: params[:state]) if params[:state]
    respond_with :api, :v1, query do |format|
      format.csv do
        send_data(Card.to_csv(query), type: "text/csv",
                  filename: 'anki-cards.csv')
      end
    end
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
