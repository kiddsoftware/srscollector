SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    @controllerFor("card").loadFirst(@store)
    @controllerFor("stats").refresh()
