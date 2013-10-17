# http://emberjs.com/guides/models/defining-a-store/

inflector = Ember.Inflector.inflector
inflector.irregular("dictionary", "dictionaries");

DS.RESTAdapter.reopen
  namespace: 'api/v1'

# We now need this if we want to use underscores instead of camel-case in our
# JSON.
SrsCollector.ApplicationSerializer = DS.ActiveModelSerializer.extend()

#SrsCollector.Store = DS.Store.extend
#  adapter: DS.RESTAdapter
