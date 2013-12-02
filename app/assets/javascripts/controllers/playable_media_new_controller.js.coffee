SrsCollector.PlayableMediaNewController = Ember.ObjectController.extend SrsCollector.AsyncMixin,
  # Wrap this property up into an array.
  subtitles_url: ((key, value) ->
    if arguments.length == 1
      array = @get("subtitles_urls")
      return null unless array?
      switch array.get("length")
        when 0 then null
        when 1 then array.objectAt(0)
        else Ember.assert("Expected 0 or 1 subtitles_urls")
    else
      @set("subtitles_urls", [value])
  ).property("subtitles_urls")

  actions:
    # TODO - This should really go in the route, but we would need to a
    # version of AsyncMixin which worked in routes.
    create: ->
      @async "Couldn't save media information.", =>
        @get('model').save()
          .then =>
            @transitionToRoute("playableMedia.show", @get('model'))
