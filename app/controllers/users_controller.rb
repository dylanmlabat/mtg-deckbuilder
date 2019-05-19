class UsersController < ApplicationController

  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'/users/show'
    else
      flash[:message] = "Please login to view account information."
      redirect '/login'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'users/new'
    else
      flash[:message] = "Currently signed in. Please logout first in order to create a new account."
      redirect "/users/#{current_user.slug}"
    end
  end

  post '/signup' do
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      flash[:error] = "All fields required in order to create account. Please try again."
      redirect '/signup'
    else
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect "/"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      flash[:message] = "Currently signed in. Please logout first in order to login to another account."
      redirect "/users/#{current_user.slug}"
    end
  end

  post '/login' do
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/"
    else
      flash[:error] = "Invalid login credentials. Please note: Both username and password are case-sensitive."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
