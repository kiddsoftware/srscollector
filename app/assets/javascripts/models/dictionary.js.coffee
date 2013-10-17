# for more details see: http://emberjs.com/guides/models/defining-models/

SrsCollector.Dictionary = DS.Model.extend
  name: DS.attr 'string'
  fromLang: DS.attr 'string'
  toLang: DS.attr 'string'
  urlPattern: DS.attr 'string'
  score: DS.attr 'number'
