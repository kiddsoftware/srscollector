SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    @controllerFor("card").set("model", @store.createRecord('card'))
    # We can't call send() on ourselves yet.
    # https://github.com/emberjs/ember.js/issues/2943
    @controllerFor("export").send("refresh")
