SrsCollector.ImportController = Ember.Controller.extend
  needs: ['card']

  value: "Sample sentence 1.\n--\nThis time, there are two sentences together.  Separate sentences with \"--\" on a line by itself, like this:\n--\nSample sentence 3."

  actions:
    # Replace blank lines with "--".  We also strip leading and trailing
    # quotes if they match up, to help with Moon+ Reader Pro output.
    replaceBlankLines: ->
      blankRegex = /\n\s*\n|\"\n\s*\n\"/g
      @set("value", @get("value").replace(blankRegex, "\n--\n"))

    # Import our new text.
    import: ->
      # TODO: Lock GUI, improve transition.
      # Sigh. Ember Data 1.0 doesn't support bulk commit, so build the request
      # by hand and call jQuery directly.
      div = $('<div>')
      cards = @get("value").split(/\n--\s*\n/).map (front) =>
        { front: div.text(front.trim()).html() }
      promise = $.ajax
        method: 'POST'
        url: '/api/v1/cards.json',
        data: JSON.stringify({ cards: cards })
        dataType: 'text' # Handle 201 CREATED responses.
        contentType: "application/json; charset=utf-8"
      promise
        .then =>
          @set("value", "")
          @get('controllers.card').send("refresh")
          @transitionToRoute('index')
        # TODO: Error-handling is special with jQuery promises. Verify this.
        .then null, (reason) =>
          # TODO: Report error to user.
          console.log("Error importing:", reason)
          return