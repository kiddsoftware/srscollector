# For more information see: http://emberjs.com/guides/routing/

SrsCollector.Router.reopen
  # Use pretty URLs without "#/" if possible.
  location: 'history'

SrsCollector.Router.map ()->
  @route('index', path: '/')
  @route('import', path: '/import')
  @route('export', path: '/export')
  @route('signUp', path: '/sign_up')
  @route('signIn', path: '/sign_in')
  @resource 'playableMedia', path: '/media', ->
    @route 'new'
  # Normally this would be the singuar form "playableMedium" without
  # ".show", but I decided that "media" in this sense is a collective noun,
  # so we just append ".show" and hope Ember works it out.
  @resource 'playableMedia.show', path: '/media/:playable_media_id'
