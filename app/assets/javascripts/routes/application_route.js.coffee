SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    @controllerFor("card").loadFirst(@store)
    @controllerFor("stats").refresh()

  actions:
    signedIn: (user) ->
      # TODO: Pass user to application controller (or something like that).
      @transitionTo('index')
