# require 'haml'
require 'sinatra/base'
require 'config/database'
require 'models'

class IdeatorApp < Sinatra::Base
  set :sessions, true

  get '/' do
    haml :index
  end

  # SASS stylesheet
  get '/stylesheets/style.css' do
    header 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end
end

