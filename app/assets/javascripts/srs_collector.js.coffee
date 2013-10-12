#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self

$ ->
  $('.wysihtml5').each (i, elem) ->
    $(elem).wysihtml5
      "font-styles": false
      "lists": false
      "image": false # Might implement as a for-pay feature some day.
      "color": true

  $("#lookup").click ->
    editor = $('.wysihtml5').data("wysihtml5").editor
    text = editor.composer.selection.getText()
    $("#dictionary").attr("src", "http://fr.wiktionary.org/wiki/" + encodeURIComponent(text))