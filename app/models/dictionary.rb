class Dictionary < ActiveRecord::Base
  belongs_to :from_language, class_name: "Language"
  validates :from_language, presence: true

  belongs_to :to_language, class_name: "Language"

  validates :name, presence: true
  validates :url_pattern, presence: true
  validates :score, presence: true
end
