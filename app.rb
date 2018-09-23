require 'sinatra/base'
require_relative './lib/game'

class RPS < Sinatra::Base

  enable :sessions

  get '/' do
    erb :index
  end

  get '/add-player' do
    erb :add_player
  end

  get '/play' do
    @player = session[:game].player1
    @move = '/move1'
    erb :play
  end

  get '/play2' do
    @player = session[:game].player2
    @move = '/move2'
    erb :play
  end

  get '/multi' do
    erb :multi
  end

  get '/result' do
    erb :result
  end

  post '/move1' do
    session[:game].add_move(params[:move])
    if session[:game].multiplayer
      redirect '/play2'
    else
      session[:game].computer_move
      redirect '/result'
    end
  end

  post '/move2' do
    session[:game].add_move(params[:move])
    redirect '/result'
  end

  post '/restart' do
    @multiplayer = session[:game].multiplayer
    session[:game] = Game.new(session[:game].player1.name,session[:game].player2.name)
    session[:game].multiplayer = @multiplayer
    redirect 'play'
  end

  post '/save-name1' do
    session[:name1] = params[:name1]
    if params[:button] == "Start game against computer"
      session[:game] = Game.new(session[:name1],'Computer')
      redirect '/play'
    else
      redirect '/add-player'
    end
  end

  post '/save-name2' do
    session[:game] = Game.new(session[:name1],params[:name2])
    session[:game].multiplayer = true
    redirect '/play'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
