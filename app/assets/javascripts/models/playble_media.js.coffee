SrsCollector.PlayableMedia = DS.Model.extend
  kind: DS.attr('string')
  url: DS.attr('string')
  language: DS.belongsTo('language')
  subtitles: DS.hasMany('subtitle', async: true)

  # A list of URLs pointing to subtitle files.  Only used when creating new
  # objects.
  subtitles_urls: DS.attr()
