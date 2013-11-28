SrsCollector.DictionariesController = Ember.ArrayController.extend
  needs: ['card']

  supporterInfoShown: false
  searchFor: null
  language: null
  currentDictionary: null

  # Find only those dictionaries which are useful for the current language.
  filtered: (->
    content = @get("content")
    language = @get("language")
    console.log("filtered", content, language)
    return [] unless content? && language?
    content.filter (d) ->
      d.get("fromLanguage") == language
  ).property("content", "language")

  url: (->
    searchFor = @get("searchFor")
    urlPattern = @get("currentDictionary.urlPattern")
    return null unless searchFor? && urlPattern
    urlPattern.replace("%s", encodeURIComponent(searchFor))
  ).property("searchFor", "currentDictionary.urlPattern")

  filteredChanged: (->
    filtered = @get("filtered")
    if filtered.get("length") > 0
      @set("currentDictionary", filtered.objectAt(0))
    else
      @set("currentDictionary", null)
  ).observes("filtered", "filtered.@each")

  searchForChanged: (->
    @set("supporterInfoShown", false)
  ).observes("searchFor")

  actions:
    showSupporterInfo: ->
      @set("supporterInfoShown", true)
