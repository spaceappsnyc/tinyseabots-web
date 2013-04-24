require 'tinyseabots/web'
require 'sequel'

module Tinyseabots
  module Web
    module Model
      DB = Sequel.connect(Tinyseabots::Web::Config.database.url)
    end
  end
end

require 'tinyseabots/web/model/robot'
require 'tinyseabots/web/model/user'
