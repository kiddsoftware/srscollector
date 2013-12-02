SrsCollector.PlayableMediaShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find('playableMedia', params.playable_media_id)

  setupController: (controller, model) ->
    @_super(controller, model)
    subtitlesController = @controllerFor("subtitles")
    subtitlesController.set("model", [])
    model.get("subtitles")
      .then (subtitles) =>
        subtitlesController.set("model", subtitles)
      .fail (reason) =>
        message = "Couldn't load subtitles."
        @controllerFor("flash").displayError(message, reason)
