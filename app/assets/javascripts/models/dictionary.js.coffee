# for more details see: http://emberjs.com/guides/models/defining-models/

SrsCollector.Dictionary = DS.Model.extend
  name: DS.attr 'string'
  fromLanguage: DS.belongsTo('Language')
  toLanguage: DS.belongsTo('Language')
  urlPattern: DS.attr 'string'
  score: DS.attr 'number'
