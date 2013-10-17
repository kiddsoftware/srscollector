require 'csv'

class Card < ActiveRecord::Base
  validates :front, presence: true
  validates(:state, presence: true,
            inclusion: %w(new reviewed exported set_aside))

  def self.to_csv(cards)
    CSV.generate do |csv|
      csv << ["Front", "Back"]
      cards.each do |card|
        csv << [card.front, card.back]
      end
    end
  end
end
