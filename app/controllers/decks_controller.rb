class DecksController < ApplicationController

  get '/decks' do
    if logged_in?
      erb :'/decks/decks'
    else
      redirect '/login'
    end
  end

end
