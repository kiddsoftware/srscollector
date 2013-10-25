class User < ActiveRecord::Base
  has_many :cards
  has_secure_password

  validates :email, presence: true, uniqueness: true

  # If it's there, it has to be unique.
  validates :api_key, uniqueness: true, allow_nil: true

  # Make sure we have an API key, saving the object as necessary.
  def ensure_api_key!
    unless api_key
      self.api_key = SecureRandom.hex(16)
      save!
    end
  end
end
