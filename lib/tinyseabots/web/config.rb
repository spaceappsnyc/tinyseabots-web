require 'tinyseabots/web'
require 'settingslogic'

class Tinyseabots::Web::Config < Settingslogic
  source ENV['CONFIG_PATH']
  namespace ENV['RACK_ENV'] || 'development'
end
