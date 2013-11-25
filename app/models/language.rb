class Language < ActiveRecord::Base
  has_many :cards
  has_many(:dictionaries_from, class_name: "Dictionary",
           foreign_key: "from_language_id")
  has_many(:dictionaries_to, class_name: "Dictionary",
           foreign_key: "to_language_id")

  validates :iso_639_1, presence: true, length: { is: 2 }, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
