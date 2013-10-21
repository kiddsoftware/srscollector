#= require_self

Application = Ember.Application.extend
  # User-visible error message.
  errorMessage: null

  # Clear any error displayed in the GUI.
  clearError: ->
    @set("errorMessage", null)

  # Display an error to the user.
  displayError: (message, reason) ->
    console.log(message, reason)
    @set("errorMessage", message)

# Instantiate our application class.
window.SrsCollector = Application.create()
