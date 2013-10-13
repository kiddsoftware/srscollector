# for more details see: http://emberjs.com/guides/models/defining-models/

SrsCollector.Card = DS.Model.extend
  state: DS.attr('string')
  front: DS.attr('string')
  back: DS.attr('string')
  source: DS.attr('string')
  sourceUrl: DS.attr('string')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
