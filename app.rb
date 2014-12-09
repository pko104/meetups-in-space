require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/meetups' do
  @all_meets = Meetup.all
  erb :'meetups/index'
end

get '/meetups/create' do
  @all_meets = Meetup.all
  erb :'meetups/create'
end


get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

post '/meetups' do

  @title = params["title"]
  @location = params["location"]
  @topic = params["topic"]

  # if !@title.empty? && !@location.empty? && !@topic.empty
  @meetup = Meetup.create(title:"#{@title}",topic:"#{@topic}",location:"#{@location}")
  @meetup.save
  @all_meets = Meetup.all
  # else
  #   @error_messages = []
  #   @error_messages << "You must enter a title." if @title.empty?
  #   @error_messages << "You must enter a topic." if @topic.empty?
  #   @error_messages << "You must enter a location." if @location.empty?

    erb :'meetups/index'
  # end

end
