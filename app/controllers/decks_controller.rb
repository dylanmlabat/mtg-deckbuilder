class DecksController < ApplicationController

  get '/decks/new' do
    if logged_in?
      erb :'decks/new'
    else
      redirect '/login'
    end
  end

  post '/decks' do
    if params[:name].empty? || params[:format].empty? ||
       params[:colors].empty? || params[:decklist].empty? ||
       !logged_in?
      redirect '/decks/new'
    else
      @deck = Deck.create(name: params[:name], format: params[:format], colors: params[:colors], decklist: params[:decklist])
      @deck.user = User.find_by(params[:id])
      @deck.save
      redirect "/decks/#{@deck.id}"
    end
  end

  get '/decks/:id' do
    if logged_in?
      @deck = Deck.find_by_id(params[:id])
      erb :'/decks/show'
    else
      redirect '/login'
    end
  end

  get '/decks/:id/edit' do
    if logged_in?
      @deck = Deck.find_by_id(params[:id])
      erb :'/decks/edit'
    else
      redirect '/login'
    end
  end

  post '/decks/:id' do
    @deck = Deck.find_by_id(params[:id])
    if params[:name].empty? || params[:format].empty? ||
       params[:colors].empty? || params[:decklist].empty? ||
       !logged_in?
      redirect "/decks/#{@deck.id}/edit"
    else
      if @deck.user == current_user
        @deck.update(name: params[:name], format: params[:format], colors: params[:colors], decklist: params[:decklist])
        @deck.save
        redirect "/decks/#{@deck.id}"
      else
        redirect "/decks/#{@deck.id}"
      end
    end
  end

  post '/decks/:id/delete' do
    if logged_in?
      @deck = Deck.find_by_id(params[:id])
      if @deck.user == current_user
        @deck.delete
        redirect '/#{@user.slug}/account'
      else
        redirect "/decks/#{@deck.id}"
      end
    else
      redirect '/login'
    end
  end

end
