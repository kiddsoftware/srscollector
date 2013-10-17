SrsCollector.CardController = Ember.ObjectController.extend
  needs: ['dictionaries', 'export']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

  # Do we have any cards to export?
  canExport: Ember.computed.alias('controllers.export.canExport')

  actions:
    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      @set("searchFor", searchFor)

    # Called when the user clicks "Next".
    nextCard: ->
      @set("state", "reviewed")
      @get("content").save()
      @get("controllers.export").send("refresh", true)
      @set("content", @store.createRecord('card'))
