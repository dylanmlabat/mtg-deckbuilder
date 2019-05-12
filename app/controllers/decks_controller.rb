class DecksController < ApplicationController

  get '/decks' do
    if logged_in?
      erb :'/decks/decks'
    else
      redirect '/login'
    end
  end

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
      @deck = Deck.find_by(params[:id])
      erb :'/decks/show'
    else
      redirect '/login'
    end
  end

end
