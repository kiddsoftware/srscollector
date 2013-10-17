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
    refresh: (haveCards=false) ->
      if haveCards
        @set("canExport", true)
      else
        @set("reviewed", SrsCollector.Card.find({ state: 'reviewed' }))
