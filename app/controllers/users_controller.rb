class UsersController < ApplicationController

  get '/account' do
    if logged_in?
      @decks = Deck.all
      erb :'/users/show'
    else
      redirect '/login'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'users/new'
    else
      erb :'/users/show'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect '/decks'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      erb :'/users/show'
    end
  end

  post '/login' do
    @user = User.find_by(params[:id])
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/decks'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/'
    else
      redirect '/'
    end
  end

end
