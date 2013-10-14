SrsCollector.IndexRoute = Ember.Route.extend
  # Temporary until we flesh things out a bit more.
  model: (params) ->
    SrsCollector.Card.createRecord()
