# Our authentication APIs.
SrsCollector.Auth = Ember.Object.extend
  # The currently signed-in user, or null if we're not logged in.
  user: null

  # Record our user, and update our csrf_token appropriately so we can
  # continue making POST calls.
  _processUserData: (json) ->
    @set("user", json["user"])
    $('meta[name="csrf-token"]').attr('content', json["csrf_token"])
    return

  # Create a new user account.
  signUpPromise: (user) ->
    jqxhr = $.ajax
      method: 'POST'
      url: "/api/v1/users.json"
      contentType: "application/json; charset=utf-8"
      data: JSON.stringify(user: user)
    Ember.RSVP.resolve(jqxhr)
      .then (json) => @_processUserData(json)

  # Sign us in as the specified user.
  signInPromise: (credentials) ->
    jqxhr = $.ajax
      method: 'POST'
      url: "/api/v1/sessions/create"
      contentType: "application/json; charset=utf-8"
      data: JSON.stringify(session: credentials)
    Ember.RSVP.resolve(jqxhr)
      .then (json) => @_processUserData(json)

  # Sign us out.  You should reload the page after calling this, because
  # there's still leftover user state scattered through Ember.js, and
  # because our csrf_token is now stale.
  signOutPromise: ->
    jqxhr = $.ajax
      method: 'POST'
      url: '/api/v1/sessions/destroy'
      dataType: 'text' # Handle 204 NO CONTENT responses.
    Ember.RSVP.resolve(jqxhr)

# Give everybody access to the authentication APIs.  This is inspired by
# how ember-auth does it.
SrsCollector.register 'auth:main', SrsCollector.Auth, singleton: true
SrsCollector.inject 'route', 'auth', 'auth:main'
SrsCollector.inject 'controller', 'auth', 'auth:main'

# This doesn't actually work reliably, so don't use it until view injection
# is fixed.
#SrsCollector.inject 'view', 'auth', 'auth:main'