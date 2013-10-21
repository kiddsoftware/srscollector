SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    SrsCollector.clearError()
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    SrsCollector.Card.next(@store)
      .then (card) =>
        @controllerFor("card").set("model", card)
      .fail (reason) =>
        SrsCollector.displayError("Couldn't load first card", reason)
    @controllerFor("stats").refresh()
