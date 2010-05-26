# require 'haml'
require 'sinatra/base'
require 'models'

class IdeatorApp < Sinatra::Base
  set :environment, 'development'

  ## CONFIGURATION
  configure :development do
    DataMapper.setup(:default, 'postgres://localhost/ideator_dev')

    DataMapper::Logger.new(STDOUT, :debug)
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

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

