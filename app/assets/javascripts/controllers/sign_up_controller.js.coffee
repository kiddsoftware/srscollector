# I need to factor this out and starting thinking about "form" controllers
# with edit a model, provide validations, and support AsyncMixin.
SrsCollector.SignUpController = Ember.Controller.extend SrsCollector.AsyncMixin,
  email: null
  password: null
  password_confirmation: null

  isValid: (->
    email = @get("email")
    return false unless email? && email.match(/^\S+\@\S+$/)
    password = @get("password")
    return false unless password? && password.match(/^\S+$/)
    password_confirmation = @get("password_confirmation")
    return false unless password_confirmation?
    return false unless password_confirmation.match(/^\S+$/)
    return false unless password == password_confirmation
    true
  ).property("email", "password", "password_confirmation")

  buttonsDisabled: (->
    @get("isBusy") || !@get("isValid")
  ).property("isBusy", "isValid")

  actions:
    signUp: ->
      @async "Could not create an account", =>
        user = @getProperties("email", "password", "password_confirmation")
        @auth.signUpPromise(user)
          .then =>
            @displayNotice("Your account has been created.")
            @transitionToRoute('index')
