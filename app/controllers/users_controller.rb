class UsersController < ApplicationController

  get '/signup' do
    if !logged_in
      erb :'users/new'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
    end
  end

end
