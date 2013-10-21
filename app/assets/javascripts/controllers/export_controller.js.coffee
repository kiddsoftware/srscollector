SrsCollector.ExportController = Ember.Controller.extend
  needs: ['stats']

  actions:
    # OK, the user says we've exported everything.
    confirmExport: ->
      SrsCollector.clearError()
      Ember.RSVP.resolve($.post("/api/v1/cards/mark_reviewed_as_exported"))
        .then =>
          @get('controllers.stats').refresh()
          @transitionToRoute('index')
        .fail (reason) =>
          SrsCollector.displayError("Couldn't mark cards as exported", reason)
