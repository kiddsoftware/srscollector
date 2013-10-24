require 'csv'

class Card < ActiveRecord::Base
  STATES = %w(new reviewed exported set_aside)

  belongs_to :user
  validates :user, presence: true

  validates :front, presence: true
  validates :state, presence: true, inclusion: STATES

  # Format source and source_url for output to Anki.
  def source_html
    case
    when source.blank? && source_url.blank?
      nil
    when source_url.blank?
      ERB::Util.h(source)
    when source.blank?
      url = ERB::Util.h(source_url)
      "<a href=\"#{url}\">#{url}</a>"
    else
      "<a href=\"#{ERB::Util.h(source_url)}\">#{ERB::Util.h(source)}</a>"
    end
  end

  def self.to_csv(cards)
    CSV.generate do |csv|
      cards.each do |card|
        csv << [card.front, card.back, card.source_html]
      end
    end
  end
end
