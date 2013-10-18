SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    SrsCollector.Card.next(@store)
      .then (card) =>
        @controllerFor("card").set("model", card)
      .fail (reason) =>
        # TODO: Report error to user.
        console.log("Failed to load first card:", reason)
    # We can't call send() on ourselves yet.
    # https://github.com/emberjs/ember.js/issues/2943
    @controllerFor("export").send("refresh")
