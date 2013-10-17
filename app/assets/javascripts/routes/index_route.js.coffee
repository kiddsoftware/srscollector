SrsCollector.IndexRoute = Ember.Route.extend
  # Temporary until we flesh things out a bit more.
  setupController: (controller) ->
    controller.set("card", SrsCollector.Card.createRecord())
    @controllerFor("dictionaries").set("model", SrsCollector.Dictionary.find())
