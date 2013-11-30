SrsCollector.Subtitle = DS.Model.extend
  playableMedia: DS.belongsTo('playableMedia')
  language: DS.belongsTo('language')
  startTime: DS.attr('number')
  endTime: DS.attr('number')
  text: DS.attr('string')
