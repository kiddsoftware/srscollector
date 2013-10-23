SrsCollector.SignUpController = Ember.Controller.extend SrsCollector.AsyncMixin,
  email: null
  password: null
  password_confirmation: null

  actions:
    signUp: ->
      @async "Error signing in", =>
        user = @getProperties("email", "password", "password_confirmation")
        jqxhr = $.ajax
          method: 'POST'
          url: "/api/v1/users.json"
          contentType: "application/json; charset=utf-8"
          data: JSON.stringify(user: user)
        Ember.RSVP.resolve(jqxhr)
          .then (json) =>
            @send("signedIn", json["user"])
