# Replace style names with single letters for size.
$.fn.wysihtml5.locale.en.emphasis.bold = "B"
$.fn.wysihtml5.locale.en.emphasis.italic = "I"
$.fn.wysihtml5.locale.en.emphasis.underline = "U"

# Configure toolbar.
$.fn.wysihtml5.defaultOptions["font-styles"] = false
$.fn.wysihtml5.defaultOptions["lists"] = false
# Might implement as a for-pay feature some day.  Needs database support.
$.fn.wysihtml5.defaultOptions["image"] = false
# We want this, but it requires us to add stylesheets to the Anki cards.
$.fn.wysihtml5.defaultOptions["color"] = false
$.fn.wysihtml5.defaultOptions["toolbar"] =
  formatting: (locale, options) ->
    "<li><div class='btn-group'><a class='btn btn-default' data-wysihtml5-command='removeFormat' title='Plain text' tabindex='-1' href='javascript:;'>P</i></a><a class='btn btn-default' data-wysihtml5-command='unlink' title='Remove links' tabindex='-1' href='javascript:;'><i class='glyphicon glyphicon-minus-sign'></i></a></div></li>"
  lookup: (locale, options) ->
    "<li><a class='btn btn-default lookup' title='Look up the selected text' tabindex='-1' href='javascript:;'>Lookup</a></li>"
$.fn.wysihtml5.defaultOptions["parserRules"] =
  tags:
    p: 1
    br: 1
    b: 1
    i: 1
    u: 1
    sup: 1
    sub: 1
    ul:
      rename_tag: "div"
    li:
      rename_tag: "div"
    # We don't actually need to remove these (they'll theoretically get
    # converted to span by default), but it's nice to remove them entirely.
    applet:
      remove: 1
    area:
      remove: 1
    audio:
      remove: 1
    base:
      remove: 1
    basefont:
      remove: 1
    bgsound:
      remove: 1
    canvas:
      remove: 1
    col:
      remove: 1
    colgroup:
      remove: 1
    command:
      remove: 1
    comment:
      remove: 1
    del:
      remove: 1
    device:
      remove: 1
    embed:
      remove: 1
    frame:
      remove: 1
    frameset:
      remove: 1
    head:
      remove: 1
    iframe:
      remove: 1
    input:
      remove: 1
    isindex:
      remove: 1
    keygen:
      remove: 1
    link:
      remove: 1
    map:
      remove: 1
    meta:
      remove: 1
    nextid:
      remove: 1
    noembed:
      remove: 1
    noframes:
      remove: 1
    noscript:
      remove: 1
    object:
      remove: 1
    param:
      remove: 1
    script:
      remove: 1
    source:
      remove: 1
    spacer:
      remove: 1
    style:
      remove: 1
    svg:
      remove: 1
    title:
      remove: 1
    track:
      remove: 1
    wbr:
      remove: 1
    video:
      remove: 1
    xml:
      remove: 1

$.fn.wysihtml5.defaultOptions["stylesheets"] = ["/assets/wysihtml5.css"]

SrsCollector.RichEditorComponent = Ember.Component.extend
  classNames: ['rich-editor']

  didInsertElement: ->
    # We call 'val' here because sometimes the underlying textarea value
    # gets lost when moving between routes.  This seems to fix it.
    @$(".wysihtml5").val(@get("value")).wysihtml5()
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
    console.log("Lookup:", text)
    if text? && !text.match(/^\s*$/)
      @editor.composer.commands.exec("bold")
      # Fire a change event manually so boldface gets written to our model.
      @editor.fire("change")
      @sendAction("lookup", text)
