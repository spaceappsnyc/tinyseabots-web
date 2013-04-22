require 'tinyseabots/web'

require 'less'
require 'rack/flash'
require 'sinatra/base'
require 'sinatra/assetpack'

class Tinyseabots::Web::App < Sinatra::Base
  register Sinatra::AssetPack

  # Configuration
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload "#{File.dirname(__FILE__)}/model/*.rb"
  end

  configure do
    # config
    config = Tinyseabots::Web::Config
    set :config, config

    # view
    set :views, "#{File.dirname(__FILE__)}/view"
    set :haml, :format => :html5

    # session
    use Rack::Session::Cookie, :secret => config.session.secret

    # method override
    use Rack::MethodOverride

    # flash
    use Rack::Flash, :accessorize => [:notice, :error] 

    # models
    User = Tinyseabots::Web::Model::User
  end

  assets do
    vendor_dir = '../../../vendor'
    # css
    Less.paths << "#{File.dirname(__FILE__)}/asset/stylesheet"
    Less.paths << File.expand_path(
      Dir["#{File.dirname(__FILE__)}/#{vendor_dir}/bundle/ruby/*/bundler/gems/bootstrap*/less"].first
    )

    serve '/css', :from => 'asset/stylesheet'

    css_compression :less
    css :application, 
      '/css/application.css', 
      [ '/css/core.css' ]

    # js
    serve '/js', :from => 'asset/js'
    js :application,
      '/js/application.js',
      []

    # images
    serve '/images', :from => 'asset/images'

    # fonts
    bootstrap_font_path = Dir["#{File.dirname(__FILE__)}/#{vendor_dir}/bundle/ruby/*/bundler/gems/bootstrap*/fonts"].first
    serve '/fonts/bootstrap', :from => bootstrap_font_path.gsub(File.dirname(__FILE__), '')
  end

  # pre route
  before do
  end

  # helpers
  helpers do
    def authorized?
      session.has_key?(:user)
    end

    def current_user(param)
      session.has_key?(:user) ? session[:user][param] : nil
    end

    def protected!
      redirect '/login' unless authorized?
    end
  end

  # routes
  get '/' do
    if session.has_key?(:user)
      redirect '/robots'
    else 
      @users = User.reverse_order(:id).all
      haml :'root/index'
    end
  end

  get '/login' do
    redirect '/' if authorized?
    @user = User.new
    haml :'root/login'
  end
 
  post '/login' do
    @user = User.find(
      :email => params[:user][:email]
    )
    
    if !@user.nil? && @user.check_password(params[:user][:password])
      session[:user] = @user.to_hash()
      redirect('/') 
    else
      @user = User.new(params[:user])
      @error = 'Invalid email or password'
      haml :'root/login'
    end 
  end
 
  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/signup' do
    redirect '/' if authorized?
    @user = User.new
    haml :'root/signup'
  end

  post '/signup' do
    redirect '/' if authorized?
    @user = User.new(params[:user])
    if @user.valid?
      @user.save
      session[:user] = @user.to_hash()
      redirect('/') 
    else  
      haml :'root/signup'
    end
  end

  get '/robots' do
    @robots = {}
    haml :'robots/index' 
  end
end
