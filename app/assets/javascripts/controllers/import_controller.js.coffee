SrsCollector.ImportController = Ember.Controller.extend
  value: "Sample sentence 1.\n--\nThis time, there are two sentences together.  Separate sentences with \"--\" on a line by itself, like this:\n--\nSample sentence 3."

  actions:
    # Replace blank lines with "--".
    replaceBlankLines: ->
      @set("value", @get("value").replace(/\"?\n\s*\n\"?/, "\n--\n"))

    # Import our new text.
    import: ->
      # TODO: Lock GUI, improve transition.
      # Sigh. Ember Data 1.0 doesn't support bulk commit, so build the request
      # by hand and call jQuery directly.
      cards = @get("value").split(/\n--\s*\n/).map (front) =>
        { front: front }
      jqxhr = $.ajax
        method: 'POST'
        url: '/api/v1/cards.json',
        data: JSON.stringify({ cards: cards })
        dataType: 'text' # Handle 201 CREATED responses.
        contentType: "application/json; charset=utf-8"
      jqxhr
        .fail (jqxhr, textStatus, errorThrown) =>
          console.log("Error importing?", textStatus, errorThrown)
        .done =>
          @set("value", "")
          @transitionToRoute('index')
