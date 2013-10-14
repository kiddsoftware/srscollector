$.fn.wysihtml5.locale.en.emphasis.bold = "B"
$.fn.wysihtml5.locale.en.emphasis.italic = "I"
$.fn.wysihtml5.locale.en.emphasis.underline = "U"

$.fn.wysihtml5.defaultOptions["font-styles"] = false
$.fn.wysihtml5.defaultOptions["lists"] = false
# Might implement as a for-pay feature some day.  Needs database support.
$.fn.wysihtml5.defaultOptions["image"] = false
$.fn.wysihtml5.defaultOptions["color"] = true
$.fn.wysihtml5.defaultOptions["toolbar"] =
  lookup: (locale, options) ->
    "<li><a class='btn btn-default lookup' title='Look up the selected text'>Lookup</a></li>"

SrsCollector.RichEditorComponent = Ember.Component.extend
  classNames: ['rich-editor']

  didInsertElement: ->
    @$(".wysihtml5").wysihtml5()
    @$(".btn.lookup").on("click", @lookup)

  willDestroyElement: ->
    @$(".btn.lookup").off("click")

  lookup: =>
    editor = @$('.wysihtml5').data("wysihtml5").editor
    text = editor.composer.selection.getText()
    url = "http://fr.wiktionary.org/wiki/#{encodeURIComponent(text)}"
    $("#dictionary").attr("src", url)
