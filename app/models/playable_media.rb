class PlayableMedia < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates :user, presence: true
  validates :language, presence: true
  validates :type, presence: true, inclusion: { in: ['audio', 'video'] }
  validates :url, presence: true
end
