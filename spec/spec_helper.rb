require 'rspec'
require 'vcr'

require 'homeaway/storm'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    hostname = 'localhost'
    scheme = :http
    port = 28080
    @client = HomeAway::Storm::Client.new hostname, port: port, scheme: scheme
  end
end

def json_pg(hash)
  require 'timeout'
  begin
    Timeout::timeout(3) do
      JSON.pretty_generate hash
    end
  rescue
    MultiJson.dump(hash)
  end
end

module VCR
  class Cassette
    class Serializers
      module JSON
        def serialize(hash)
          handle_encoding_errors do
            json_pg hash
          end
        end
      end
    end
  end
end


VCR.configure do |c|
  c.cassette_library_dir = 'cassettes/'
  c.hook_into :webmock
  c.default_cassette_options = {record: :all,
                                serialize_with: :json,
                                preserve_exact_body_bytes: true
  }
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end