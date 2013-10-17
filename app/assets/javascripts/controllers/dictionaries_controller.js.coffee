SrsCollector.DictionariesController = Ember.ArrayController.extend
  searchFor: null
  currentDictionary: null

  url: (->
    searchFor = @get("searchFor")
    urlPattern = @get("currentDictionary.urlPattern")
    return null unless searchFor? && urlPattern
    urlPattern.replace("%s", encodeURIComponent(searchFor))
  ).property("searchFor", "currentDictionary.urlPattern")

  contentChanged: (->
    content = @get("content")
    if content.get("length") > 0
      @set("currentDictionary", content.objectAt(0))
    else
      @set("currentDictionary", null)
  ).observes("content", "content.length")