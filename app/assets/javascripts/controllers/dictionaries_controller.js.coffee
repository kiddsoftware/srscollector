SrsCollector.DictionariesController = Ember.ArrayController.extend
  needs: ['card']

  sortProperties: ['score']
  sortAscending: false

  supporterInfoShown: false
  searchFor: null
  language: null
  currentDictionary: null

  # Used to keep track of the dictionary when none is shown.  We should
  # probably make this per-language at some point, perhaps by creating
  # a languages controller and item controllers for each language.
  previousDictionary: null

  # Find only those dictionaries which are useful for the current language.
  filtered: (->
    content = @get("arrangedContent")
    language = @get("language")
    return [] unless content? && language?
    content.filter (d) ->
      d.get("fromLanguage") == language
  ).property("arrangedContent", "language")

  url: (->
    searchFor = @get("searchFor")
    urlPattern = @get("currentDictionary.urlPattern")
    return null unless searchFor? && urlPattern
    urlPattern.replace("%s", encodeURIComponent(searchFor))
  ).property("searchFor", "currentDictionary.urlPattern")

  filteredChanged: (->
    filtered = @get("filtered")
    current = @get("currentDictionary")
    previous = @get("previousDictionary")
    if current? && filtered.contains(current)
      # It's valid, so leave it alone.
    else if previous? && filtered.contains(previous)
      # It's valid, so restore it.
      @set("currentDictionary", previous)
      @set("previousDictionary", null)
    else if filtered.get("length") > 0
      @set("currentDictionary", filtered.objectAt(0))
    else
      @set("previousDictionary", current) if current
      @set("currentDictionary", null)
  ).observes("filtered", "filtered.@each")

  searchForChanged: (->
    @set("supporterInfoShown", false)
  ).observes("searchFor")

  actions:
    showSupporterInfo: ->
      @set("supporterInfoShown", true)
