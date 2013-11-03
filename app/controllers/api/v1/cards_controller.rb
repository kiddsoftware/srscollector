class API::V1::CardsController < ApplicationController
  prepend_before_filter :allow_api_key, only: [:create, :stats]
  before_filter :authenticate_user!

  respond_to :json
  respond_to :csv, only: :index
  respond_to :zip, only: :index

  def index
    query = user_cards
    query = query.where(state: params[:state]) if params[:state]
    query = query.order("created_at, id") if params[:sort] == 'age'
    query = query.limit(params[:limit].to_i) if params[:limit]
    respond_with :api, :v1, query do |format|
      format.csv do
        send_data(Card.to_csv(query), type: "text/csv",
                  filename: 'anki-cards.csv')
      end
      format.zip do
        send_data(Card.to_media_zip(query), type: "application/zip",
                  filename: 'anki-media.zip')
      end
    end
  end

  def stats
    states = Hash[Card::STATES.map {|s| [s, 0] }]
    states.merge!(user_cards.group(:state).count)
    render json: { stats: { state: states } }
  end

  def show
    respond_with :api, :v1, user_cards.find(params[:id])
  end

  def create
    if params[:cards]
      params[:cards].each do |card|
        attrs = card.slice(:state, :front, :back, :source, :source_url)
        user_cards.create!(attrs)
      end
      head :created
    else
      respond_with :api, :v1, user_cards.create(card_params)
    end
  end

  def mark_reviewed_as_exported
    user_cards.where(state: 'reviewed').update_all(state: 'exported')
    head :no_content
  end

  def update
    respond_with :api, :v1, user_cards.update(params[:id], card_params)
  end

  def destroy
    respond_with :api, :v1, user_cards.destroy(params[:id])
  end

  protected

  # Limit ourselves to the cards associated with this user.
  def user_cards
    current_user.cards
  end

  # Specify legal parameters using the new Rails 4 "Strong Parameters."
  def card_params
    params.required(:card).permit(:state, :front, :back, :source, :source_url)
  end
end
