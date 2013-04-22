require 'tinyseabots/web/model'

require 'SecureRandom'

class Tinyseabots::Web::Model::Robot < Sequel::Model(:robot)
  plugin :json_serializer 
  plugin :timestamps
  plugin :validation_helpers
  one_to_one :user, :class => :'Tinyseabots::Web::Model::User'

  def validate
    super

    validates_presence [:name, :location]
  end

  def before_create
    super 

    self.api_key = SecureRandom.uuid if self.api_key.nil?
  end
end
