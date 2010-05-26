# require 'haml'
gem 'sinatra', '= 1.0'
require 'sinatra/base'
require 'config/database'
require 'models'
require 'haml'
require 'sass'
require 'sanitize'

class IdeatorApp < Sinatra::Base
  set :sessions, true
  set :haml, {:format => :html5 }
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }

  helpers do
    def label_for id, name
      "<label for='#{id}'>#{name}</label>"
    end

    def slider_for id
      haml(
       ".slider &nbsp;\n" +
       "%span.caption 1\n" +
       "%input.value{:type => 'hidden', :value => '#{@record.new? ? 1 : @record.send(id)}', :id => '#{id}', :name => '#{id}'}")
    end

    def partial identifier, opts={}
      options = {
        :locals => {}
      }.merge!(opts)
      haml "_#{identifier}".to_sym, :locals => options[:locals]
    end

    def h str
      Sanitize.clean(str)
    end
  end

  not_found do
    "This idea is nowhere to be found, <a href='/'>go back</a>."
  end


  before do
    @ideas = Idea.all
  end

  get '/' do
    @record = Idea.new
    haml :index
  end

  get '/idea/:id' do
    @record = Idea.get(params[:id])
    if @record.nil?
      halt 404
    end
    @highlight = @record.id
    haml :index
  end

  post '/update/:id' do
    idea = Idea.get(params[:id])
    if idea
      idea.attributes = {
        :name => params[:name],
        :clarity_of_audience => params[:clarity_of_audience],
        :clarity_of_problem => params[:clarity_of_problem],
        :clarity_of_need => params[:clarity_of_need],
        :clarity_of_ability_to_meet_need => params[:clarity_of_ability_to_meet_need]
      }
      idea.save
    else
      halt 404
    end

    redirect "/idea/#{ params[:id] }"
  end

  post '/create' do
    Idea.create(
      :name => params[:name],
      :clarity_of_audience => params[:clarity_of_audience],
      :clarity_of_problem => params[:clarity_of_problem],
      :clarity_of_need => params[:clarity_of_need],
      :clarity_of_ability_to_meet_need => params[:clarity_of_ability_to_meet_need]
    )

    redirect '/'
  end

  post '/delete/:id' do
    idea = Idea.get( params[:id] )
    if idea.nil?
      halt 404
    end

    idea.destroy!

    redirect '/'
  end

  # SASS stylesheet
  get '/style.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end
end

