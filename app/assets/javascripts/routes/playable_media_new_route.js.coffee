SrsCollector.PlayableMediaNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord('playableMedia')
