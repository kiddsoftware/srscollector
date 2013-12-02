SrsCollector.PlayableMediaIndexRoute = Ember.Route.extend
  model: ->
    @store.find('playableMedia')
