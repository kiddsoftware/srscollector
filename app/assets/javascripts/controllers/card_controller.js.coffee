SrsCollector.CardController = Ember.ObjectController.extend SrsCollector.AsyncMixin,
  needs: ['stats', 'dictionaries']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

  # Refresh ourselves when a user logs in or out.
  userChanged: (-> @refresh()).observes("auth.user")

  # Can we discard the user's work in progress here?
  canDiscard: (->
    return true unless @get("isDirty")
    front = @get("front")
    return false if front? && front != ""
    back = @get("back")
    return false if back? && back != ""
    true
  ).property("isDirty", "front", "back")

  # Try to update our current content, if possible.  Returns a promise.
  refresh: ->
    if @get("canDiscard")
      SrsCollector.Card.nextPromise(@store, @auth).then (next) =>
        @set("content", next)
        return
    else
      new Ember.RSVP.Promise (resolve, reject) => resolve()

  insertDefinitionPlaceholder: (phrase) ->
    back = @get("back") ? ""
    unless back == ""
      back += "<br><br>"
    html = $('<div>').text(phrase).html()
    @set("back", back + html + " =&nbsp;")

  loadFirst: (store, auth) ->
    @async "Couldn't load first card.", =>
      SrsCollector.Card.nextPromise(store, @auth)
        .then (card) =>
          @set("content", card)

  saveAndNext: (state) ->
    @set("state", state)
    @async "Couldn't update card.", =>
      @get("content").save()
        .then =>
          @get("controllers.stats").refresh()
          @refresh()

  actions:
    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      # Delay our call to insertDefinitionPlaceholder so the boldface text
      # from our lookup has a chance to stick before we call
      # getValue/setValue on our editor.
      Ember.run.next this, ->
        @insertDefinitionPlaceholder(searchFor)
        @set("searchFor", searchFor)

    # Called when the user clicks "Next".
    nextCard: ->
      @saveAndNext("reviewed")

    # Called when the user clicks "Next".
    setAside: ->
      @saveAndNext("set_aside")
