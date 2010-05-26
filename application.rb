require 'haml'
require 'json'

require 'sinatra/base'

class IdeatorApp < Sinatra::Base
  set :sessions, true

  get '/' do
    haml :index
  end
end

