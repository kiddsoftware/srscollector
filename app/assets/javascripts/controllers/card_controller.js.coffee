SrsCollector.CardController = Ember.ObjectController.extend
  needs: ['dictionaries', 'export']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

  # Do we have any cards to export?
  canExport: Ember.computed.alias('controllers.export.canExport')

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
    console.log("Trying to refresh...")
    if @get("canDiscard")
      console.log("Refreshing...")
      SrsCollector.Card.next(@store).then (next) =>
        @set("content", next)
        return
    else
      new Ember.RSVP.Promise (resolve, reject) => resolve()

  actions:
    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      @set("searchFor", searchFor)

    # Called when the user clicks "Next".
    nextCard: ->
      @set("state", "reviewed")
      @get("content").save()
        .then =>
          @get("controllers.export").send("refresh", true)
          @refresh()
        .fail (reason) =>
          # TODO: Report error to user.
          console.log("Failed to load next card:", reason)

    refresh: ->
      @refresh()
