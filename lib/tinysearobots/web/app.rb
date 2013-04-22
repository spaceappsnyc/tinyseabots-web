require 'tinysearobots/web'

require 'less'
require 'rack/flash'
require 'sinatra/base'
require 'sinatra/assetpack'

class Tinysearobots::Web::App < Sinatra::Base
  register Sinatra::AssetPack

  # Configuration
  configure do
    # config
    config = Tinysearobots::Web::Config
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

    # auth

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

  # models
  User = Tinysearobots::Web::Model::User

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
      redirect '/hacks'
    else 
      @users = User.reverse_order(:id).all
      haml :'root/index'
    end
  end

  get '/login' do
    redirect '/' if authorized?
    haml :'root/login'
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
    return haml :'root/signup' unless @user.save

    session[:user] = @user
    res.redirect('/') 
  end
end
