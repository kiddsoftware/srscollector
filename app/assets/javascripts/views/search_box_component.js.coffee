SrsCollector.SearchBoxComponent = Ember.Component.extend
  classNames: ['search-box', 'input-group']

  # The official value of the search box.  Does not change until the user
  # is done.
  value: null

  # The actual value edited by the user.
  editedValue: null

  valueChanged: (->
    @set("editedValue", @get("value"))
  ).observes("value")

  actions:
    # Commit the user's search query.
    search: ->
      @set("value", @get("editedValue"))
