SrsCollector.SignUpController = Ember.Controller.extend SrsCollector.AsyncMixin,
  email: null
  password: null
  password_confirmation: null

  actions:
    signUp: ->
      @async "Could not create an account", =>
        user = @getProperties("email", "password", "password_confirmation")
        @auth.signUpPromise(user)
          .then =>
            @displayNotice("Your account has been created.")
            @transitionToRoute('index')
