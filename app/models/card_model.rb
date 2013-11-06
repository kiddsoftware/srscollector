class CardModel < ActiveRecord::Base
  has_many :card_model_fields
  has_many :cards

  validates :short_name, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :anki_front_template, presence: true
  validates :anki_back_template, presence: true
  validates :anki_css, presence: true
end
