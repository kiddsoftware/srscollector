# I need to factor this out and starting thinking about "form" controllers
# with edit a model, provide validations, and support AsyncMixin.
SrsCollector.SignInController = Ember.Controller.extend SrsCollector.AsyncMixin,
  email: null
  password: null
  remember_me: false

  isValid: (->
    email = @get("email")
    return false unless email? && email.match(/^\S+\@\S+$/)
    password = @get("password")
    return false unless password? && password.match(/^\S+$/)
    true
  ).property("email", "password")

  buttonsDisabled: (->
    @get("isBusy") || !@get("isValid")
  ).property("isBusy", "isValid")

  actions:
    signIn: ->
      @async "Error signing in. Please double-check your username and password.", =>
        credentials = @getProperties("email", "password", "remember_me")
        @auth.signInPromise(credentials)
          .then =>
            @transitionToRoute('index')
