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

require 'singleton'

module HomeAway
  module Storm
    module Util
      # @private
      class Defaults
        include Singleton

        def port
          '8080'
        end

        def scheme
          :http
        end

        def logger
          default_logger = Logger.new(STDOUT)
          default_logger.level = Logger::WARN
          default_logger
        end

        def cache_control
          'max-age: 0, must-revalidate'
        end

        def connection_opts
          {}
        end

        def adapter
          :faraday
        end

        def to_hash
          keys = self.class.instance_methods(false)
          keys.delete(:to_hash)
          hash = {}
          keys.each do |key|
            hash[key] = send key
          end
          hash
        end
      end.freeze
      Defaults.instance.freeze
    end
  end
end