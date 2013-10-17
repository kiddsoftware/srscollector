SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", SrsCollector.Dictionary.find())
    @controllerFor("card").set("model", SrsCollector.Card.createRecord())
    # We can't call send() on ourselves yet.
    # https://github.com/emberjs/ember.js/issues/2943
    @controllerFor("export").send("refresh")
