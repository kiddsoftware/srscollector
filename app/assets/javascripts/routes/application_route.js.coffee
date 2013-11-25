SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    @store.find('language')
      .then (languages) => @controllerFor("card").set("languages", languages)
      .fail (reason) =>
        message = "Could not load languages"
        @get("flash").displayError(message, reason)
    @controllerFor("card").loadFirst(@store, @auth)
    @controllerFor("stats").refresh()

  actions:
    signOut: ->
      jqxhr = $.ajax
        method: 'POST'
        url: '/api/v1/sessions/destroy'
        dataType: 'text' # Handle 204 NO CONTENT responses.
      Ember.RSVP.resolve(jqxhr)
        .then =>
          window.location.reload()
        .fail =>
          alert("Could not log out!")