# Our authentication APIs.
SrsCollector.Auth = Ember.Object.extend
  # The currently signed-in user, or null if we're not logged in.
  currentUser: null

  # Sign us in as the specified user.
  signIn: (user) ->
    @set("currentUser", user)

# Give everybody access to the authentication APIs.  This is inspired by
# how ember-auth does it.
SrsCollector.register 'auth:main', SrsCollector.Auth, singleton: true
SrsCollector.inject 'route', 'auth', 'auth:main'
SrsCollector.inject 'controller', 'auth', 'auth:main'

# This doesn't actually work reliably, so don't use it until view injection
# is fixed.
#SrsCollector.inject 'view', 'auth', 'auth:main'