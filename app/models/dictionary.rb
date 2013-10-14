class Dictionary < ActiveRecord::Base
  validates :name, presence: true
  validates :from_lang, presence: true
  validates :to_lang, presence: true
  validates :url_pattern, presence: true
  validates :score, presence: true
end
