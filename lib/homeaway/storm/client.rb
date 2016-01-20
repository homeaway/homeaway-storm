# Copyright (c) 2016 HomeAway.com, Inc.
# All rights reserved.  http://www.homeaway.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module HomeAway
  module Storm
    class Client

      # @return [Hash] the global default configuration
      def self.default_configuration
        @@default_configuration ||= HomeAway::Storm::Util::Defaults.instance.to_hash
      end

      # Pass a block expecting a single hash parameter and set any global configuration settings
      # that will be inherited by all instances created in the future
      # @return [Hash] the global default configuration
      def self.configure
        yield @@default_configuration if block_given?
        @@default_configuration
      end

      attr_accessor :configuration

      # @!attribute [rw] configuration
      #   @return [Hash] the current client configuration

      # Instantiates a new Storm API client
      #
      # @param hostname [String] the hostname of the storm cluster
      # @return [HomeAway::Storm::Client] a newly instantiated Storm API client
      def initialize(hostname, opts={})
        config = {
            hostname: hostname
        }.merge(opts)
        @configuration = Hashie::Mash.new(self.class.default_configuration.merge(config))
        validate_configuration
        logger.debug("client initialized with configuration: #{@configuration}")
      end

      # Update the configuration of this particular instance of the client.
      # Pass a block expecting a single hash parameter to update the configuration settings.
      # @return [Hash] This client's configuration
      def configure
        yield @configuration if block_given?
        validate_configuration
        @configuration
      end

      # @return [Object] The current logger that has been configured
      def logger
        @configuration.logger
      end

      # @private
      def marshal_dump
        # we lose our logger instance naively here, marshal dump doesn't like
        # one of its fields
        dump_config = configuration.dup.to_hash
        dump_config.delete('logger')
        [dump_config]
      end

      # @private
      def marshal_load(array)
        @configuration = Hashie::Mash.new(array.first)
        @configuration.logger = HomeAway::Storm::Util::Defaults.instance.logger
      end

      # @private
      def get(url, params={})
        method :get, url, {}, params
      end

      # @private
      def put(url, body, params={})
        method :put, url, body, params
      end

      # @private
      def post(url, body, params={})
        method :post, url, body, params
      end

      # @private
      def delete(url, params={})
        method :delete, url, {}, params
      end

      # @private
      def options(url, params={})
        method :options, url, {}, params
      end

      private

      def validate_configuration
        required_fields = [:hostname]
        [required_fields].flatten.each do |required_configuration_directive|
          raise ArgumentError.new("#{required_configuration_directive.to_s} is required but not supplied") if (@configuration[required_configuration_directive] == nil || @configuration[required_configuration_directive].nil? || !configuration.has_key?(required_configuration_directive))
        end
        true
      end


      def adapter
        registered_adapters = {
            :faraday => HomeAway::Storm::Adapters::FaradayAdapter,
        }
        raise ArgumentError.new("Invalid adapter #{@configuration[:adapter]}") unless registered_adapters.keys.include? @configuration[:adapter]
        registered_adapters[@configuration[:adapter]]
      end

      def headers
        headers = {}
        headers['Cache-control'] = @configuration[:cache_control]
        headers['User-Agent'] = "HomeAway Storm ruby_sdk/#{HomeAway::Storm::VERSION}"
        headers
      end

      def method(method, url, body, params)
        logger.info("#{method.to_s.upcase} to #{url} with params #{params.to_json}")
        site = @configuration[:hostname]
        port = @configuration[:port]
        scheme = @configuration[:scheme]
        conn_opts = @configuration[:connection_opts]
        response = adapter.call(site, port, scheme, conn_opts, headers, method, url, body, params)
        logger.debug("returning payload: #{response.to_json}")
        response
      end

    end
  end
end

require 'homeaway/storm/domain/client_includes'