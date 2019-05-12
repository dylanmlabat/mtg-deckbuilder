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
       !logged_in
      redirect '/decks/new'
    else
      @deck = Deck.create(params[:name], params[:format], params[:colors], params[:decklist])
      @deck.user = params[:username]
      @deck.save
    end
  end

end
