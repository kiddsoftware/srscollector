# http://emberjs.com/guides/models/defining-a-store/

inflector = Ember.Inflector.inflector
inflector.irregular("dictionary", "dictionaries");

SrsCollector.Adapter = DS.RESTAdapter.extend
  namespace: 'api/v1'

# We now need this if we want to use underscores instead of camel-case in our
# JSON.
SrsCollector.ApplicationSerializer = DS.ActiveModelSerializer.extend()

SrsCollector.Store = DS.Store.extend
  adapter: SrsCollector.Adapter
