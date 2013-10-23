# Displays messages to the user.  The actual API is on our
# main application object so that it's accessible from everywhere.
SrsCollector.FlashController = Ember.Controller.extend
  noticeMessage: null
  errorMessage: null

  # Clear any error displayed in the GUI.
  clearFlash: ->
    @set("noticeMessage", null)
    @set("errorMessage", null)

  # Display a notice to the user, usually because something succeeded.
  displayNotice: (message) ->
    @set("noticeMessage", message)

  # Display an error to the user.
  displayError: (message, reason) ->
    console.log(message, reason)
    @set("errorMessage", message)
