SrsCollector.CardController = Ember.ObjectController.extend SrsCollector.AsyncMixin,
  needs: ['stats', 'dictionaries']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

  # Is the user allowed to have images on cards?
  imagesAllowed: Ember.computed.alias('auth.isSupporter')

  # Is the user allowed to translate text?
  translateAllowed: Ember.computed.alias('auth.isSupporter')

  # Refresh ourselves when a user logs in or out.
  userChanged: (-> @refresh()).observes("auth.user")

  # Do we need to disable our "Next" button?
  saveDisabled: (->
    @get("isBusy") || !@get("front")?
  ).property("isBusy", "front")

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

  addTextToCardBack: (txt) ->
    back = @get("back") ? ""
    unless back == ""
      back += "<br><br>"
    html = $('<div>').text(txt).html().replace(/\ $/, '&nbsp;')
    @set("back", back + html)

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
    # Called when our rich text editors send a "translate" event.
    # We have a stupid parameter-passing convention because sendAction
    # only supports one argument.
    translate: (args) ->
      [text, isSelection] = args
      if @get("translateAllowed")
        @async "Couldn't translate text.", =>
          jqxhr = $.ajax
            type: "POST"
            url: "/api/v1/languages/translate.json"
            data: JSON.stringify({ text: text })
            contentType: "application/json; charset=utf-8"
          jqxhr.then (json) =>
            translation = json['translation']
            if isSelection
              @addTextToCardBack("#{text} = #{translation}")
            else
              @addTextToCardBack(translation)
      else
        @get("controllers.dictionaries").send("showSupporterInfo")

    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      @addTextToCardBack("#{searchFor} = ")
      @set("searchFor", searchFor)

    # Called when the user clicks "Next".
    nextCard: ->
      @saveAndNext("reviewed")

    # Called when the user clicks "Next".
    setAside: ->
      @saveAndNext("set_aside")
