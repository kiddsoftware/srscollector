SrsCollector.ExportController = Ember.Controller.extend
  needs: ['stats']

  actions:
    # OK, the user says we've exported everything.
    confirmExport: ->
      $.post("/api/v1/cards/mark_reviewed_as_exported")
        .then =>
          @get('controllers.stats').refresh()
          @transitionToRoute('index')
        .then null, (reason) =>
          # TODO: Report error to user.
          console.log("Couldn't mark cards as exported")
          return
