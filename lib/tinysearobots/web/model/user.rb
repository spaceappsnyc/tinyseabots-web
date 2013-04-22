require 'tinysearobots/web/model'

class Tinysearobots::Web::Model::User < Sequel::Model(:user)
  plugin :json_serializer 
  plugin :timestamps
  plugin :validation_helpers
  one_to_many :robots, :class => :'Tinysearobots::Web::Model::Robot'

  def validate
    super

    validates_presence [:name, :email, :password]
 
    validates_format(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/,
      :email,
      :message => 'is not valid')
  
    validates_min_length 8, :password, 'must be at least 8 characters'
  end
end
