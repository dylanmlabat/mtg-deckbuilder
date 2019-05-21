require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "mtg-secret"
  end

  get "/" do
    @decks = Deck.all
    @recent_decks = @decks.reverse[0..4]
    erb :index
  end

  helpers do
    def current_user
      current_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
      !!current_user
    end
  end

end
