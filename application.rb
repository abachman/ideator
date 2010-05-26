require 'haml'
require 'json'

require 'sinatra/base'

class MyApp < Sinatra::Base
  set :sessions, true

  get '/' do
    haml 'index'
  end
end

