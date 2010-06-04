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

    def link_to text, url=nil
      haml "%a{:href => '#{ url || text }'} #{ text }"
    end

    def link_to_unless_current text, url=nil
      if url == request.path_info
        text
      else
        link_to text, url
      end
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

  def load_bevy
    if !params[:token].nil?
      @bevy = Bevy.get(params[:token])
    end
    halt(404) if @bevy.nil?

    @current_url = "http://ideator.heroku.com/#{ @bevy.token }"

    load_records
  end

  def load_records
    @ideas = @bevy.ideas
    # used in form
    @record = Idea.new
  end

  # SASS stylesheet
  get '/style.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

  get '/' do
    # create a new bevy
    @bevy = Bevy.new
    @bevy.token = Bevy.generate_token
    @bevy.save!

    redirect "/#{ @bevy.token }"
  end

  get '/:token/about' do
    load_bevy
    haml :about, :layout => 'layouts/default'.to_sym
  end

  get '/:token/idea/:id' do
    load_bevy

    @record = Idea.first(:id => params[:id], :bevy_token => @bevy.token)
    if @record.nil?
      halt 404
    end
    @highlight = @record.id

    haml 'ideas/index'.to_sym, :layout => 'layouts/default'.to_sym
  end

  post '/:token/update/:id' do
    load_bevy

    idea = Idea.first(:id => params[:id], :bevy_token => @bevy.token)
    if idea.nil?
      halt 404
    end

    idea.attributes = {
      :name => params[:name],
      :clarity_of_audience => params[:clarity_of_audience],
      :clarity_of_problem => params[:clarity_of_problem],
      :clarity_of_need => params[:clarity_of_need],
      :clarity_of_ability_to_meet_need => params[:clarity_of_ability_to_meet_need]
    }
    idea.save

    redirect "/#{ @bevy.token }"
  end

  post '/:token/create' do
    load_bevy

    @idea = Idea.create(
      :name => params[:name],
      :clarity_of_audience => params[:clarity_of_audience],
      :clarity_of_problem => params[:clarity_of_problem],
      :clarity_of_need => params[:clarity_of_need],
      :clarity_of_ability_to_meet_need => params[:clarity_of_ability_to_meet_need],
      :bevy_token => @bevy.token
    )

    redirect "/#{ @bevy.token }"
  end

  post '/:token/delete/:id' do
    load_bevy

    idea = Idea.first(:id => params[:id], :bevy_token => @bevy.token)
    if idea.nil?
      halt 404
    end

    idea.destroy!

    redirect "/#{ @bevy.token }"
  end

  # default route
  get '/:token' do
    load_bevy

    haml 'ideas/index'.to_sym, :layout => 'layouts/default'.to_sym
  end
end

