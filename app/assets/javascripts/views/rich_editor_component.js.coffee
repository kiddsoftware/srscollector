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
  formatting: (locale, options) ->
    "<li><div class='btn-group'><a class='btn btn-default' data-wysihtml5-command='removeFormat' title='Plain text' tabindex='-1' href='javascript:;'>P</i></a><a class='btn btn-default' data-wysihtml5-command='unlink' title='Remove links' tabindex='-1' href='javascript:;'><i class='glyphicon glyphicon-minus-sign'></i></a></div></li>"
  lookup: (locale, options) ->
    "<li><a class='btn btn-default lookup' title='Look up the selected text' tabindex='-1' href='javascript:;'>Lookup</a></li>"

SrsCollector.RichEditorComponent = Ember.Component.extend
  classNames: ['rich-editor']

  didInsertElement: ->
    @$(".wysihtml5").wysihtml5()
    @editor = @$('.wysihtml5').data("wysihtml5").editor
    @editor.on("change", @onEditorChange.bind(this))
    @editor.on("paste", @onPaste.bind(this))
    @$(".btn.lookup").on("click", @onLookup.bind(this))

  willDestroyElement: ->
    @$(".btn.lookup").off("click")
    #@editor.off("change")
    #@editor.off("paste")
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

  onPaste: ->
    # Clean up nasty &nbsp; garbage that appears when we paste from some
    # sites.
    @editor.setValue(@editor.getValue().replace(/&nbsp;/g, ' '))

  onLookup: ->
    text = @editor.composer.selection.getText()
    if text? && !text.match(/^\s*$/)
      @editor.composer.commands.exec("bold")
      # Fire a change event manually so boldface gets written to our model.
      @editor.fire("change")
      @sendAction("lookup", text)
