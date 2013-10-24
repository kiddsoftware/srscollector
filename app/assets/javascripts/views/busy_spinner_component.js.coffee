SrsCollector.BusySpinnerComponent = Ember.Component.extend
  tagName: 'span'
  classNames: ['busy-spinner']
  classNameBindings: ['isBusy:visible:invisible']

  # Normally bound to `isBusy` from `AsyncMixin`.
  #isBusy: null
