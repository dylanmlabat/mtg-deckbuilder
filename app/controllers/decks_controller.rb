class DecksController < ApplicationController

  get '/decks/new' do
    if logged_in?
      erb :'decks/new'
    else
      flash[:message] = "Please login first in order to create a new deck."
      redirect '/login'
    end
  end

  post '/decks' do
    if params[:name].empty? || params[:format].empty? ||
       params[:colors] == nil || params[:decklist].empty? ||
       !logged_in?
      flash[:error] = "All fields required in order to create deck. Please try again."
      redirect "/decks/new"
    else
      @deck = Deck.create(name: params[:name], format: params[:format], colors: params[:colors].join(", "), decklist: params[:decklist])
      @deck.user = current_user
      @deck.save
      redirect "/decks/#{@deck.slug}"
    end
  end

  get '/decks/:slug' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      erb :'/decks/show'
    else
      flash[:message] = "Please login to view deck information."
      redirect '/login'
    end
  end

  get '/decks/:slug/edit' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      if @deck.user == current_user
        erb :'/decks/edit'
      else
        flash[:error] = "Cannot edit another user's deck."
        redirect "/decks/#{@deck.slug}"
      end
    else
      flash[:message] = "Please login first in order to edit a deck."
      redirect '/login'
    end
  end

  patch '/decks/:slug' do
    @deck = Deck.find_by_slug(params[:slug])
    if params[:name].empty? || params[:format].empty? ||
       params[:colors] == nil || params[:decklist].empty? ||
       !logged_in?
      flash[:error] = "All fields required in order to update deck. Please try again."
      redirect "/decks/#{@deck.slug}/edit"
    else
      if @deck.user == current_user
        @deck.update(name: params[:name], format: params[:format], colors: params[:colors].join(", "), decklist: params[:decklist])
        @deck.save
        redirect "/decks/#{@deck.slug}"
      else
        flash[:error] = "Cannot edit another user's deck."
        redirect "/decks/#{@deck.slug}"
      end
    end
  end

  delete '/decks/:slug/delete' do
    if logged_in?
      @deck = Deck.find_by_slug(params[:slug])
      if @deck.user == current_user
        @deck.delete
        redirect "/users/#{@deck.user.slug}"
      else
        flash[:error] = "Cannot delete another user's deck."
        redirect "/decks/#{@deck.slug}"
      end
    else
      flash[:message] = "Please login first in order to delete a deck."
      redirect '/login'
    end
  end

end
