class Card < ActiveRecord::Base
  validates :front, presence: true
  validates(:state, presence: true,
            inclusion: %w(new reviewed exported set_aside))
end
