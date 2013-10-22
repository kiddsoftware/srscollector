SrsCollector.AsyncMixin = Ember.Mixin.create
  # (Internal.) Do we have an active asyncBegin?
  asyncActive: false

  # Is this controller busy?  This field can be passed as the 'disabled'
  # attribute of <input> elements.
  busy: Ember.computed.alias("asyncActive")

  # Start a asynchronous operation.
  asyncBegin: ->
    @set("asyncActive", true)
    SrsCollector.clearError()

  # End an asynchronous operation successfully.
  asyncEndSuccess: ->
    @set("asyncActive", false)

  # End an asynchronous operation unsuccessfully.
  asyncEndFailure: (message, reason) ->
    @set("asyncActive", false)
    SrsCollector.displayError(message, reason)

  # Run `func` asynchronously, displaying `errorMessage` if it fails.
  # `func` must return a promise.
  async: (errorMessage, func) ->
    @asyncBegin()
    Ember.RSVP.resolve(null)
      .then(-> func())
      .then(=> @asyncEndSuccess())
      .fail((reason) => @asyncEndFailure(errorMessage, reason))
