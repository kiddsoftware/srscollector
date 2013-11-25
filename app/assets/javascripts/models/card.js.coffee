# for more details see: http://emberjs.com/guides/models/defining-models/

SrsCollector.Card = DS.Model.extend
  state: DS.attr('string', defaultValue: 'new')
  language: DS.belongsTo('language')
  front: DS.attr('string')
  back: DS.attr('string')
  source: DS.attr('string')
  sourceUrl: DS.attr('string')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')

SrsCollector.Card.reopenClass
  # Fetch the next card to review or creates a new one.  Returns a promise.
  # TODO: In case of error?
  nextPromise: (store, auth) ->
    if auth.user?
      store.find('card', { state: 'new', sort: 'age', limit: 1 })
        .then (cards) =>
          if cards.get("length") == 0
            store.createRecord('card')
          else
            cards.objectAt(0)
    else
      card = store.createRecord('card')
      new Ember.RSVP.Promise (resolve, reject) => resolve(card)
