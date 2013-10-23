# For more information see: http://emberjs.com/guides/routing/

SrsCollector.Router.map ()->
  @route('index', path: '/')
  @route('import', path: '/import')
  @route('export', path: '/export')
  @route('sign_up', path: '/sign_up')
  @route('sign_in', path: '/sign_in')
