require 'csv'

class Card < ActiveRecord::Base
  STATES = %w(new reviewed exported set_aside)

  validates :front, presence: true
  validates :state, presence: true, inclusion: STATES

  def self.to_csv(cards)
    CSV.generate do |csv|
      cards.each do |card|
        csv << [card.front, card.back]
      end
    end
  end
end
