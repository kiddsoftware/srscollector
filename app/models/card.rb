class Card < ActiveRecord::Base
  validates :front, presence: true

  state_machine initial: :new do
  end
end
