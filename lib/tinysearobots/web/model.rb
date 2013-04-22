require 'tinysearobots/web'
require 'sequel'

module Tinysearobots
  module Web
    module Model
      DB = Sequel.connect(Tinysearobots::Web::Config.database.url)
    end
  end
end

require 'tinysearobots/web/model/user'
