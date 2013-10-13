# http://emberjs.com/guides/models/defining-a-store/

SrsCollector.Adapter = DS.RESTAdapter.extend
  namespace: 'api/v1'

SrsCollector.Store = DS.Store.extend
  revision: 11
  adapter: SrsCollector.Adapter.create()
