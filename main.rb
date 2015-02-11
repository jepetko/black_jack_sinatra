require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'lib/src/black_jack.rb'
require_relative 'lib/src/support/black_jack_interactive_adapter.rb'
require_relative 'lib/src/support/object_to_hash_serialization_support.rb'
require_relative 'lib/src/support/black_jack_utils.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'
#set :sessions, true

#######################################

get '/' do
	erb :index
end

get '/replay' do
  BlackJackUtils.create_game!(session)
end

post '/play' do
  session[:name] = params[:name]
  BlackJackUtils.create_game!(session)
  erb :play
end

get '/start' do
  if !session[:black_jack].nil?
    black_jack = session[:black_jack]
    if black_jack.players.first.cards.nil?
      black_jack.give_first_cards
    end
  end
end

get '/draw' do
  if !session[:black_jack].nil?
    black_jack = session[:black_jack]

    # check whether the game is done..
    state_hash = BlackJackUtils.get_game_state_as_hash(session)
    if state_hash[:state] == 'done'
      return state_hash.to_json
    end

    # let the players draw a card
    name = session[:name]
    answer = params[:answer]

    all = black_jack.players + [black_jack.dealer]
    all.each do |player|
      if player.busted?
        next
      end
      if player.dealer?
        if player.should_stay?
          next
        end
      end
      if player.name == name
        if answer != 'Y'
          next
        end
      end
      card = black_jack.stack.give
      if card.nil?
        break
      end
      player.draw(card)
    end
  end
  # return the state of the game after this round
  BlackJackUtils.get_game_state_as_hash(session).to_json
end

get '/players.json' do
  content_type :json
  BlackJackUtils.get_players_as_hash(session)
end