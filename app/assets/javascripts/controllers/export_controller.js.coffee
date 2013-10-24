SrsCollector.ExportController = Ember.Controller.extend SrsCollector.AsyncMixin,
  needs: ['stats']

  actions:
    # OK, the user says we've exported everything.
    confirmExport: ->
      @async "Couldn't mark cards as exported.", =>
        Ember.RSVP.resolve($.post("/api/v1/cards/mark_reviewed_as_exported"))
          .then =>
            @displayNotice("Your cards have been marked as exported.")
            @get('controllers.stats').refresh()
            @transitionToRoute('index')
