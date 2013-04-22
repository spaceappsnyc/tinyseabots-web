require 'tinysearobots/web'
require 'settingslogic'

class Tinysearobots::Web::Config < Settingslogic
  source ENV['CONFIG_PATH']
  namespace ENV['RACK_ENV'] || 'development'
end
