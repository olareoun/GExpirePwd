require 'sinatra/base'
require 'sinatra/contrib'
require 'mongoid'
require 'logger'

$LOAD_PATH.push(File.expand_path(File.join(File.dirname(__FILE__), '../')))

require_relative './lib/notifier'
require_relative '../users/lib/users_domain'

require_relative 'base_app'
require_relative 'login'

require_relative 'lib/google_authentication'

class Web < BaseApp

  helpers Sinatra::GoogleAuthentication

  set :public_folder, './web/public'
  set :static, true

  before do
    require_authentication
    @domain = session[:domain]
    @userEmail = session[:user_attributes][:email]
  end

  get '/index.html' do
    erb :index, :layout => :home_layout
  end

  get '/' do
    @message = Notifier.message_for params['alert_signal']
    erb :index, :layout => :home_layout
  end

  get '/users' do
    begin
      email = @userEmail
      @userNames = Users::UsersDomain.new.getUsers email
      erb :users, :layout => :home_layout
    rescue
      showError 'not.admin'
    end
  end

  post '/changePasswordNextTime' do
    Users::UsersDomain.new.changePasswordNextTime @userEmail, params['email']
      @userNames = Users::UsersDomain.new.getUsers @userEmail
      erb :users, :layout => :home_layout
  end

  def showError(messageKey)
      @message = Notifier.message_for messageKey
      erb :index, :layout => :home_layout
  end

  def strToArray(usersStr)
    return [] if usersStr.nil?
    usersStr.split(',')
  end

end
