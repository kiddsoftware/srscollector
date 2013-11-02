class MediaFile < ActiveRecord::Base
  belongs_to :card
  has_attached_file :file

  validates :card, presence: true
  validates_attachment :file,
    presence: true,
    content_type: { content_type: /^image\/(jpg|png|gif)$/ },
    size: { in: 0..128.kilobytes }
end
