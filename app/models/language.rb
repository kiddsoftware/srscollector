class Language < ActiveRecord::Base
  has_many :cards

  validates :iso_639_1, presence: true, length: { is: 2 }, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
