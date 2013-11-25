# for more details see: http://emberjs.com/guides/models/defining-models/

SrsCollector.Dictionary = DS.Model.extend
  name: DS.attr 'string'
  fromLanguage: DS.belongsTo('language')
  toLanguage: DS.belongsTo('language')
  urlPattern: DS.attr 'string'
  score: DS.attr 'number'
