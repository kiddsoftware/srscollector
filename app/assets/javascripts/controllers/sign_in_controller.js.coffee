SrsCollector.SignInController = Ember.Controller.extend SrsCollector.AsyncMixin,
  email: null
  password: null

  actions:
    signIn: ->
      @async "Error signing in. Please double-check your username and password.", =>
        credentials = @getProperties("email", "password")
        @auth.signInPromise(credentials)
          .then =>
            @transitionToRoute('index')
