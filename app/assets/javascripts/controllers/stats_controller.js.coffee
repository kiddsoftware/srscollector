SrsCollector.StatsController = Ember.ObjectController.extend
  refresh: ->
    Ember.RSVP.resolve($.get("/api/v1/cards/stats.json"))
      .then (json) =>
        @set("content", Ember.Object.create(json['stats']['state']))
      .fail (reason) =>
        # We're not important enough to notify the user.
        console.log("Couldn't fetch statistics", reason)
