SrsCollector.CardController = Ember.ObjectController.extend
  needs: ['stats', 'dictionaries']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

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
      SrsCollector.Card.next(@store).then (next) =>
        @set("content", next)
        return
    else
      new Ember.RSVP.Promise (resolve, reject) => resolve()

  insertDefinitionPlaceholder: (phrase) ->
    back = @get("back") ? ""
    unless back == ""
      back += "<br><br>"
    html = $('<div>').text(phrase).html()
    @set("back", back + html + " = ")

  saveAndNext: (state) ->
    SrsCollector.clearError()
    @set("state", state)
    @get("content").save()
      .then =>
        @get("controllers.stats").refresh()
        @refresh()
      .fail (reason) =>
        SrsCollector.displayError("Couldn't update card", reason)

  actions:
    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      @insertDefinitionPlaceholder(searchFor)
      @set("searchFor", searchFor)

    # Called when the user clicks "Next".
    nextCard: ->
      @saveAndNext("reviewed")

    # Called when the user clicks "Next".
    setAside: ->
      @saveAndNext("set_aside")
