SrsCollector.Language = DS.Model.extend
  iso639_1: DS.attr('string')
  name: DS.attr('string')
  dictionariesFrom: DS.hasMany('Dictionary', inverse: 'fromLanguage')
  dictionariesTo: DS.hasMany('Dictionary', inverse: 'toLanguage')
