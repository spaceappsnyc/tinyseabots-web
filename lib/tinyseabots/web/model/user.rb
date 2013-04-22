require 'tinyseabots/web/model'
require 'bcrypt'

class Tinyseabots::Web::Model::User < Sequel::Model(:user)
  plugin :json_serializer 
  plugin :timestamps
  plugin :validation_helpers
  one_to_many :robots, :class => :'Tinyseabots::Web::Model::Robot'

  def check_password(password)
    begin
      valid_password = BCrypt::Password.new(self.password) == password
      return valid_password 
    rescue
      return false
    end
  end

  def password=(value)
    @password_ = value
    super(BCrypt::Password.create(value))
  end

  def validate
    super

    validates_presence [:email, :password]

    validates_unique :email, :message => 'is already registered'
    validates_format(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/,
      :email,
      :message => 'is not valid')
  
    validates_min_length(8,
      @_password,
      :message =>'must be at least 8 characters'
    )
  end
end
