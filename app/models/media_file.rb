class MediaFile < ActiveRecord::Base
  belongs_to :card
  has_attached_file :file

  validates :card, presence: true
end
