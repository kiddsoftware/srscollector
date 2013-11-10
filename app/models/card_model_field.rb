class CardModelField < ActiveRecord::Base
  belongs_to :card_model
  validates :card_model, presence: true

  validates :order, uniqueness: { scope: :card_model_id }
  validates :name, uniqueness: { scope: :card_model_id }
  validates :card_attr, uniqueness: { scope: :card_model_id }
end
