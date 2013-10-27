class User < ActiveRecord::Base
  has_many :cards
  has_secure_password

  validates :email, presence: true, uniqueness: true

  # If it's there, it has to be unique.
  validates :api_key, uniqueness: true, allow_nil: true

  def ensure_api_key!
    ensure_token!(:api_key)
  end

  def ensure_auth_token!
    ensure_token!(:auth_token)
  end

  def clear_auth_token!
    self.auth_token = nil
    save!
  end

  protected

  # Make sure we have the specified token, saving the object as necessary.
  def ensure_token!(field)
    unless send(field)
      send("#{field}=", SecureRandom.hex(16))
      save!
    end
  end
end
