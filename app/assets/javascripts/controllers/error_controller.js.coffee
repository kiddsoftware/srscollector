# Displays error messages to the user.  The actual API is on our
# main application object so that it's accessible from everywhere.
SrsCollector.ErrorController = Ember.Controller.extend
  errorMessageBinding: "SrsCollector.errorMessage"
