module ApplicationHelper
  attr_reader :current_user

  # The current user, as a JSON string, for embedding in page templates
  # where Ember.js can find it.  There are other ways to do this, but
  # this one is the simplest.
  def serialized_current_user
    UserSerializer.new(current_user).to_json.html_safe
  end
end
