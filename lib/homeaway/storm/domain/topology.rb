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
    module Domain
      module Topology
        def topology_summary
          get '/api/v1/topology/summary'
        end

        def topology(id, opts={})
          get "/api/v1/topology/#{id}", opts
        end

        def topology_component(id, component, opts={})
          get "/api/v1/topology/#{id}/component/#{component}", opts
        end

        def topology_activate(id)
          post "/api/v1/topology/#{id}/activate", {}
        end

        def topology_deactivate(id)
          post "/api/v1/topology/#{id}/deactivate", {}
        end

        def topology_rebalance(id, wait_time, rebalance_opts={})
          body = {}
          body[:rebalanceOptions] = rebalance_opts unless rebalance_opts.empty?
          post "/api/v1/topology/#{id}/rebalance/#{wait_time}", body
        end

        def topology_kill(id, wait_time)
          post "/api/v1/topology/#{id}/kill/#{wait_time}", {}
        end
      end
    end
  end
end