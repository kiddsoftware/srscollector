SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    SrsCollector.Card.next(@store)
      .then (card) =>
        @controllerFor("card").set("model", card)
      .fail (reason) =>
        # TODO: Report error to user.
        console.log("Failed to load first card:", reason)
    @controllerFor("stats").refresh()
