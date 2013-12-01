class UserSerializer < ActiveModel::Serializer
  attributes(:id, :email, :supporter, :features)

  # What features are enabled for this user?  Returns a list of strings.
  def features
    ROLLOUT_CLIENT_FEATURES.select do |feature|
      ROLLOUT.active?(feature, object)
    end.map(&:to_s)
  end
end
