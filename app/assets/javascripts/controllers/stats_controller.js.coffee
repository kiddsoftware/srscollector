
SrsCollector.StatsController = Ember.ObjectController.extend
  # Refresh ourselves when a user logs in or out.
  userChanged: (-> @refresh()).observes("auth.user")

  refresh: ->
    if @auth.get("user")
      Ember.RSVP.resolve($.get("/api/v1/cards/stats.json"))
        .then (json) =>
          @set("content", Ember.Object.create(json['stats']['state']))
        .fail (reason) =>
          # We're not important enough to notify the user.
          console.log("Couldn't fetch statistics", JSON.stringify(reason))
    return
