SrsCollector.PlayableMedia = DS.Model.extend
  kind: DS.attr('string')
  url: DS.attr('string')
  language: DS.belongsTo('language')
  subtitles: DS.hasMany('subtitle', async: true)
