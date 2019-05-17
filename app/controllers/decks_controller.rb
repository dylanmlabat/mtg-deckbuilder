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
      @deck.user = User.find_by_id(params[:id])
      @deck.save
      redirect "/decks/#{@deck.slug}"
    end
  end

  get '/decks/:slug' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      erb :'/decks/show'
    else
      redirect '/login'
    end
  end

  get '/decks/:slug/edit' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      erb :'/decks/edit'
    else
      redirect '/login'
    end
  end

  post '/decks/:slug' do
    @deck = Deck.find_by_slug(params[:slug])
    if params[:name].empty? || params[:format].empty? ||
       params[:colors].empty? || params[:decklist].empty? ||
       !logged_in?
      redirect "/decks/#{@deck.slug}/edit"
    else
      if @deck.user == current_user
        @deck.update(name: params[:name], format: params[:format], colors: params[:colors], decklist: params[:decklist])
        @deck.save
        redirect "/decks/#{@deck.slug}"
      else
        redirect "/decks/#{@deck.slug}"
      end
    end
  end

  post '/decks/:slug/delete' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      if @deck.user == current_user
        @deck.delete
        redirect "/#{current_user.slug}/account"
      else
        redirect "/decks/#{@deck.slug}"
      end
    else
      redirect '/login'
    end
  end

end
