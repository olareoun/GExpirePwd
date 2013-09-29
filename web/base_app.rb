require 'sinatra/base'

class BaseApp < Sinatra::Base

  use Rack::Session::Cookie

  configure do
    set :run, false
    Mongoid.load!("config/mongoid.yml")
  end

end