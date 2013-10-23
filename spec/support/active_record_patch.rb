# See http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/

# Note that this will occasionally cause subtle bad things to happen during
# tests.  One fix that we need is to put the following in
# config/environments/test.rb:
#
#   config.middleware.delete "ActiveRecord::QueryCache"

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
 
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
 
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
