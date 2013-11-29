class Subtitle < ActiveRecord::Base
  belongs_to :playable_media
  belongs_to :language

  validates :playable_media, presence: true
  validates :language, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :text, presence: true
end
