# require 'haml'
gem 'sinatra', '= 1.0'
require 'sinatra/base'
require 'config/database'
require 'models'
require 'haml'
require 'sass'
require 'sanitize'

class IdeatorApp < Sinatra::Base
  set :session, true
  set :haml, {:format => :html5 }
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }

  helpers do
    def label_for id, name, options={}
      "<label class='#{options[:class]}' for='#{id}'>#{name}</label>"
    end

    def slider_for id, value
      haml(
       ".slider &nbsp;\n" +
       "%span.caption #{value || 1}\n" +
       "%input.value{:type => 'hidden', :value => '#{value || 1}', :id => '#{id}', :name => '#{id}'}")
    end

    def partial identifier, opts={}
      options = {
        :locals => {}
      }.merge!(opts)
      haml identifier.to_sym, :locals => options[:locals]
    end

    def h str
      Sanitize.clean(str)
    end

    def link_to text, url
      haml "%a{:href => '#{ url }'} #{ text }"
    end

    # from rails: actionpack/lib/action_view/helpers/url_helper.rb
    # simply post to a given url
    def javascript_post_function(href=nil)
      action = href ? "'#{href}'" : 'this.href'
      submit_function =
        "var f = document.createElement('form'); f.style.display = 'none'; " +
        "this.parentNode.appendChild(f); f.method = 'POST'; f.action = #{action}; f.submit(); return false;"
    end
  end

  not_found do
    "This idea is nowhere to be found, <a href='/'>go back</a>."
  end

  before do
    @ideas = Idea.all.sort_by {|a| a.name.downcase}
    @record = Idea.new
  end

  get '/' do
    # haml 'index'.to_sym, :layout => 'layouts/default'.to_sym
    haml 'ideas/index'.to_sym, :layout => 'layouts/default'.to_sym
  end

  get '/:token' do
    pass if true
    haml 'bevys/index'.to_sym, :layout => 'layouts/default'.to_sym
  end

  get '/idea/:id' do
    @record = Idea.get(params[:id])
    if @record.nil?
      halt 404
    end
    @highlight = @record.id
    haml 'ideas/index'.to_sym, :layout => 'layouts/default'.to_sym
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

    redirect "/"
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

