class CardModel < ActiveRecord::Base
  has_many :card_model_fields, -> { order('"order" ASC') }
  has_many :card_model_templates, -> { order('"order" ASC') }
  has_many :cards

  validates :short_name, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :anki_css, presence: true
end
