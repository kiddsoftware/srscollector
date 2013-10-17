# http://emberjs.com/guides/models/defining-a-store/

inflector = Ember.Inflector.inflector
inflector.irregular("dictionary", "dictionaries");

DS.RESTAdapter.reopen
  namespace: 'api/v1'

#SrsCollector.Store = DS.Store.extend
#  adapter: DS.RESTAdapter
