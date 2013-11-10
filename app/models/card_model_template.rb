class CardModelTemplate < ActiveRecord::Base
  belongs_to :card_model

  validates :name, presence: true
  validates :anki_front_template, presence: true
  validates :anki_back_template, presence: true
end
