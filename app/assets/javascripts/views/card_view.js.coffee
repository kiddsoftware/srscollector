SrsCollector.CardView = Ember.View.extend
  didInsertElement: ->
    @$("option:first").prop("disabled", true)
