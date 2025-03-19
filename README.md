# PROXMOX CLIENT

Client REST PROXMOX API

Author: Maxime Désécot <maxime.desecot@gmail.com>

## Build

OS: Linux distribution LTS

Language: Ruby3.1+

```
$ apt install ruby
$ gem install bundler
$ git clone git@github.com:RaoH37/proxmox-client.git
$ cd proxmox-client
$ bundle install
$ gem build proxmox-client.gemspec
```

## Installation

OS: Linux distribution LTS

Language: Ruby3.1+

```
$ apt install ruby
$ gem install bundler
$ gem install proxmox-client-1.0.0.gem
```

## Examples of uses:

### Connection:

```ruby
proxmox = Proxmox::Application.new do |config|
  config.endpoint = 'https://proxmox.local:8006'
  config.base_path = 'api2'
  config.username = 'maxime'
  config.password = 'secret'
  config.realm = 'pmg'
end

proxmox.login
````
or you can also initialize your connection from a configuration file :
```ruby
proxmox = Proxmox::Application.new do |config|
  config.load_from_path('./config.json')
end

proxmox.login
````

### Usage

```ruby
response = proxmox.connector.get('json/statistics/domains', data: { starttime: 1727733600, endtime: 1730415600 })
response[:data].each do |data|
  puts data
end
````