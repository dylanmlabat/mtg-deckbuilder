class DecksController < ApplicationController

  get '/:user/decks/new' do
    if logged_in?
      erb :'decks/new'
    else
      redirect '/login'
    end
  end

  post '/:user/decks' do
    if params[:name].empty? || params[:format].empty? ||
       params[:colors].empty? || params[:decklist].empty? ||
       !logged_in?
      redirect "/#{current_user.slug}/decks/new"
    else
      @deck = Deck.create(name: params[:name], format: params[:format], colors: params[:colors], decklist: params[:decklist])
      @deck.user = current_user
      @deck.save
      redirect "/#{current_user.slug}/decks/#{@deck.slug}"
    end
  end

  get '/:user/decks/:slug' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      erb :'/decks/show'
    else
      redirect '/login'
    end
  end

  get '/:user/decks/:slug/edit' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      erb :'/decks/edit'
    else
      redirect '/login'
    end
  end

  patch '/:user/decks/:slug' do
    @deck = Deck.find_by_slug(params[:slug])
    if params[:name].empty? || params[:format].empty? ||
       params[:colors].empty? || params[:decklist].empty? ||
       !logged_in?
      redirect "/#{current_user.slug}/decks/#{@deck.slug}/edit"
    else
      if @deck.user == current_user
        @deck.update(name: params[:name], format: params[:format], colors: params[:colors], decklist: params[:decklist])
        @deck.save
        redirect "/#{current_user.slug}/decks/#{@deck.slug}"
      else
        redirect "/#{current_user.slug}/decks/#{@deck.slug}"
      end
    end
  end

  delete '/:user/decks/:slug/delete' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      if @deck.user == current_user
        @deck.delete
        redirect "/#{current_user.slug}/account"
      else
        redirect "/#{current_user.slug}/decks/#{@deck.slug}"
      end
    else
      redirect '/login'
    end
  end

end
