SrsCollector.ImportController = Ember.Controller.extend SrsCollector.AsyncMixin,
  needs: ['stats', 'card']

  value: "Sample sentence 1.\n--\nThis time, there are two sentences together.  Separate sentences with \"--\" on a line by itself, like this:\n--\nSample sentence 3."
  source: null
  sourceUrl: null

  actions:
    # Replace blank lines with "--".
    replaceBlankLines: ->
      @set("value", @get("value").replace(/\n\s*\n/g, "\n--\n"))

    # This is useful for Moon+ Reader Pro, which quotes each snippet.
    parseQuotedSentences: ->
      separated = @get("value").replace(/\n*\"\n\s*\n\"\n*/g, "\n--\n")
      @set("value", separated.replace(/^\"/, "").replace(/\"$/, ""))

    importClippings: ->
      @async "Couldn't import the clippings file.", =>
        promise = new Ember.RSVP.Promise (resolve, reject) =>
          $("#clippings-form").ajaxSubmit
            type: "POST"
            iframe: true
            url: "/api/v1/cards.clippings"
            error: -> reject(new Error("Could not submit form"))
            success: -> resolve()
        promise
          .then =>
            @get('controllers.card').refresh()
            @get('controllers.stats').refresh()
            @transitionToRoute('index')

    # Import our new text.
    import: ->
      @async "Couldn't import the cards.", =>
        # Sigh. Ember Data 1.0 doesn't support bulk commit, so build the request
        # by hand and call jQuery directly.
        source = @get("source")
        sourceUrl = @get("sourceUrl")
        div = $('<div>')
        cards = @get("value").split(/\n--\s*\n/).map (front) =>
          card =
            front: div.text(front.trim()).html().replace(/\n/, '<br>')
            source: source
            source_url: sourceUrl
          card
        jqxhr = $.ajax
          method: 'POST'
          url: '/api/v1/cards.json',
          data: JSON.stringify({ cards: cards })
          dataType: 'text' # Handle 201 CREATED responses.
          contentType: "application/json; charset=utf-8"
        Ember.RSVP.resolve(jqxhr)
          .then =>
            @set("value", "")
            @get('controllers.card').refresh()
            @get('controllers.stats').refresh()
            @transitionToRoute('index')
