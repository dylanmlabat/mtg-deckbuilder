class UsersController < ApplicationController

  get '/:user/account' do
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
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/#{@user.slug}/account"
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
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/#{@user.slug}/account"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
