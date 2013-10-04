require 'sinatra/base'

class BaseApp < Sinatra::Base

  use Rack::Session::Cookie, secret: 'change_me'

  configure do
    set :run, false
    Mongoid.load!("config/mongoid.yml")
  end

end