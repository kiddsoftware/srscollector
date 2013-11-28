SrsCollector.Language = DS.Model.extend
  iso639_1: DS.attr('string')
  name: DS.attr('string')
  cards: DS.hasMany('card')
  dictionariesFrom: DS.hasMany('dictionary', inverse: 'fromLanguage')
  dictionariesTo: DS.hasMany('dictionary', inverse: 'toLanguage')
