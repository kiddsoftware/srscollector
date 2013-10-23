SrsCollector.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    @controllerFor("dictionaries").set("model", @store.find('dictionary'))
    @controllerFor("card").loadFirst(@store)
    @controllerFor("stats").refresh()

  actions:
    signOut: ->
      jqxhr = $.ajax
        method: 'POST'
        url: '/api/v1/sessions/destroy.json'
        dataType: 'text' # Handle 204 NO CONTENT responses.
      Ember.RSVP.resolve(jqxhr)
        .then =>
          window.location.reload()
        .fail =>
          alert("Could not log out!")