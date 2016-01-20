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

require 'spec_helper'

describe HomeAway::Storm, :vcr do
  it 'can get the topology summary' do
    expect {
      summary = @client.topology_summary
      expect(summary).to respond_to :topologies
      if summary.topologies.size > 0
        topology = summary.topologies.first
        expect(topology).to respond_to :id, :name
      end
    }.to_not raise_error
  end

  it 'can get a particular topology' do
    topology_summary = @client.topology_summary.topologies.first
    topology = @client.topology(topology_summary.id, sys: true)
    expect(topology.name).to eql topology_summary.name
    expect(topology).to respond_to :spouts, :bolts, :status
  end

  it 'can get a particular topology component' do
    topology_summary = @client.topology_summary.topologies.first
    topology = @client.topology(topology_summary.id, sys: true)
    expect(topology).to respond_to :spouts, :bolts
    bolt = topology.bolts.first
    component = @client.topology_component(topology.id, bolt.bolt_id, sys: true, window: 10)
    expect(component.id).to eql bolt.bolt_id
  end

  it 'can get a topology component with a window' do
    window = 10
    topologies = @client.topology_summary.topologies
    summary = topologies.select { |t| t.name == 'exclamation-topology' }.first
    topology = @client.topology(summary.id, sys: true)
    bolt = @client.topology_component(topology.id, 'exclaim1', :window => window.to_s)
    expect(bolt.window).to eql window.to_s
  end
end
