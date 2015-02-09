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

    if black_jack.check_done_conditions == true
      winner = black_jack.detect_winner
      if !winner.nil?
        return winner.as_hash.to_json
      end
    end

    all = black_jack.players + [black_jack.dealer]
    all.each do |player|
      if black_jack.check_done_conditions == true
        return black_jack.detect_winner.as_hash.to_json
      end
      if player.busted?
        continue
      end
      if player.dealer?
        if player.should_stay?
          continue
        end
      end
      if player.name == name
        if answer != 'Y'
          continue
        end
      end
      card = black_jack.stack.give
      if card.nil?
        break
      end
      player.draw(card)
    end
  end
  {:message => 'running'}.as_hash.to_json
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