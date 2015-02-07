require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'lib/src/black_jack.rb'
require_relative 'lib/src/support/black_jack_interactive_adapter.rb'
require_relative 'lib/src/support/object_to_hash_serialization_support.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'
#set :sessions, true

#######################################

get '/' do
	erb :index
end

post '/play' do
  session[:name] = params[:name]

  black_jack = BlackJack.new
  session[:black_jack] = black_jack
  black_jack.kick_off? { session[:name] }
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
    name = session[:name]
    black_jack = session[:black_jack]
    answer = params[:answer]

    all = players + dealer
    all.each do |player|
      if check_done_conditions
        break
      end
      # detect the next player. Player can be asked:
      # a) if he is not busted
      # b) if he is not the *dealer* whose score >= 17 (then he must stay)
      accept_player = lambda {|player|
        if player.busted?
          return false
        else
          if player.dealer?
            return !player.should_stay?
          end
        end
        true
      }
      player = next_player accept_player
      card = stack.give
      player.draw(card)
    end
  end
end

get '/players.json' do
  content_type :json
  if session[:black_jack].nil?
    [].to_json
  else
    black_jack = session[:black_jack]
    winner = black_jack.detect_winner
    hash = black_jack.players.as_hash
    black_jack.players.each_with_index do |p,idx|
      if p.busted?
        hash[idx][:busted] = true
      end
      if p.name == winner.name
        hash[idx][:winner] = true
      end
    end
    hash.to_json
  end
end

get '/dealers.json' do
  content_type :json
  if session[:black_jack].nil?
    {}.to_json
  else
    session[:black_jack].dealer.as_hash.to_json
  end
end