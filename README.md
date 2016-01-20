# Homeaway::Storm

A Ruby SDK to interact with [Apache Storm](https://storm.apache.org/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'homeaway-storm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install homeaway-storm

## Usage

```ruby
    hostname = 'localhost'
    scheme = :http
    port = 28080
    @client = HomeAway::Storm::Client.new hostname, port: port, scheme: scheme
    puts "this Storm cluster has a web UI running on port #{@client.cluster_configuration['ui.port']}"
```

More detailed example usage is available in the accompanying tests that exist in the spec folder. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/homeaway/homeaway-storm.

