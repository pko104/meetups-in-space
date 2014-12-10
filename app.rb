require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

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

get '/meetups/:id' do
  @meet = Meetup.find_by(id: params[:id])
  @rsvp = Rsvp.find_by(meetup_id: params[:id])
  #binding.pry
  if @rsvp != nil
  @message_board = Post.where(rsvp_id: @rsvp.id)
  end
  @listed = Rsvp.find_by(user_id: current_user, meetup_id: params[:id])
  #binding.pry
   erb :'meetups/single'
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




post '/meetups/:id' do
  @message = params["message"]
  @meetup_destroy = params["meetup_destroy"]
  if @meetup_destroy !=nil
  @destroyer = Rsvp.find_by(user_id: current_user.id, meetup_id: params[:id])
  @destroyer.destroy
  else
  @attendee = Rsvp.create(user_id: current_user.id, meetup_id: params[:id])
  end
  if @message !=nil
  @rsvp = Rsvp.find_by(meetup_id: params[:id])
  @newmsg = Post.create(message: @message, rsvp_id: @rsvp.id)
  end
  #binding.pry
  redirect "/meetups/#{params[:id]}"
end

post '/meetups' do

  @meetup_id = params["meetup_id"]
  @title = params["title"]
  @location = params["location"]
  @topic = params["topic"]
  @meetup = Meetup.new(title:"#{@title}",location:"#{@location}",topic:"#{@topic}")
  @meetup.save
  @all_meets = Meetup.all
  if !@meetup.save
    flash[:notice] = @meetup.errors.full_messages.join(' ')
  end
    redirect '/meetups'

end
