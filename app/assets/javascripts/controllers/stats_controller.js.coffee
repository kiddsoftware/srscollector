SrsCollector.StatsController = Ember.ObjectController.extend
  refresh: ->
    Ember.RSVP.resolve($.get("/api/v1/cards/stats.json"))
      .then (json) =>
        @set("content", Ember.Object.create(json['stats']['state']))
      .fail (reason) =>
        # TODO: Report error to user.
        console.log("Can't fetch statistics:", reason)
