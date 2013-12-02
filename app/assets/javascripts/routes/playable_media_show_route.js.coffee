SrsCollector.PlayableMediaShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find('playableMedia', params.playable_media_id)
