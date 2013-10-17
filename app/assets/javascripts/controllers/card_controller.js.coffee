SrsCollector.CardController = Ember.ObjectController.extend
  needs: ['dictionaries']

  # Link this local field to the correponding field in our dictionaries
  # controller.
  searchFor: Ember.computed.alias('controllers.dictionaries.searchFor')

  actions:
    # Called when our rich text editors send a "lookup" event.
    lookup: (searchFor) ->
      @set("searchFor", searchFor)
