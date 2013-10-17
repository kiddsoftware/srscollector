# Replace style names with single letters for size.
$.fn.wysihtml5.locale.en.emphasis.bold = "B"
$.fn.wysihtml5.locale.en.emphasis.italic = "I"
$.fn.wysihtml5.locale.en.emphasis.underline = "U"

# Configure toolbar.
$.fn.wysihtml5.defaultOptions["font-styles"] = false
$.fn.wysihtml5.defaultOptions["lists"] = false
# Might implement as a for-pay feature some day.  Needs database support.
$.fn.wysihtml5.defaultOptions["image"] = false
$.fn.wysihtml5.defaultOptions["color"] = true
$.fn.wysihtml5.defaultOptions["toolbar"] =
  lookup: (locale, options) ->
    "<li><a class='btn btn-default lookup' title='Look up the selected text' tabindex='-1' href='javascript:;'>Lookup</a></li>"

SrsCollector.RichEditorComponent = Ember.Component.extend
  classNames: ['rich-editor']

  didInsertElement: ->
    @$(".wysihtml5").wysihtml5()
    @editor = @$('.wysihtml5').data("wysihtml5").editor
    @editor.on("change", @onEditorChange.bind(this))
    @$(".btn.lookup").on("click", @onLookup.bind(this))

  willDestroyElement: ->
    @$(".btn.lookup").off("click")
    #@editor.off("change")
    @editor = null

  onModelChange: (->
    value = @get("value")
    @editor.setValue(value, true)
    # Fix our placeholder.  The editor should really take care of this itself!
    if value?
      @editor.fire("unset_placeholder")
    else
      @editor.fire("set_placeholder")
  ).observes("value")

  onEditorChange: ->
    # Copy this back manually.  We might need to tweak this some more.
    @set("value", @editor.getValue())

  onLookup: ->
    text = @editor.composer.selection.getText()
    if text? && !text.match(/^\s*$/)
      @sendAction("lookup", text)
