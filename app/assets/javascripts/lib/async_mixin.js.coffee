SrsCollector.AsyncMixin = Ember.Mixin.create
  needs: 'flash'

  # (Internal.) Do we have an active asyncBegin?
  asyncActive: false

  # Is this controller busy?  This field can be passed as the 'disabled'
  # attribute of <input> elements.
  isBusy: Ember.computed.alias("asyncActive")

  # Start a asynchronous operation.
  asyncBegin: ->
    @set("asyncActive", true)
    @get("controllers.flash").clearFlash()

  # End an asynchronous operation successfully.
  asyncEndSuccess: ->
    @set("asyncActive", false)

  # End an asynchronous operation unsuccessfully.
  asyncEndFailure: (message, reason) ->
    @set("asyncActive", false)
    @get("controllers.flash").displayError(message, reason)

  # Display a notice after a successful operation.
  displayNotice: (message) ->
    @get("controllers.flash").displayNotice(message)

  # Run `func` asynchronously, displaying `errorMessage` if it fails.
  # `func` must return a promise.
  async: (errorMessage, func) ->
    @asyncBegin()
    Ember.RSVP.resolve(null)
      .then(-> func())
      .then(=> @asyncEndSuccess())
      .fail((reason) => @asyncEndFailure(errorMessage, reason))
