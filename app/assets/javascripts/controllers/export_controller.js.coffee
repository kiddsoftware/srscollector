SrsCollector.ExportController = Ember.Controller.extend
  # Cards that are ready to export.
  reviewed: []

  reviewedChanged: (->
    if @get("reviewed.length") > 0
      @set("canExport", true)
  ).observes("reviewed.length")

  # Do we have any cards to export?
  canExport: false

  actions:
    # Send this event to let us know that the list of exportable cards may
    # have changed.
    refresh: (haveCards='check') ->
      if haveCards == 'check'
        @set("reviewed", @store.find('card', { state: 'reviewed' }))
      else
        @set("canExport", haveCards)

    # OK, the user says we've exported everything.
    confirmExport: ->
      @send("refresh", false)
      jqxhr = $.post("/api/v1/cards/mark_reviewed_as_exported")
      jqxhr.fail =>
        console.log("Couldn't mark cards as exported")
      jqxhr.done =>
        @transitionToRoute('index')
