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
    black_jack = session[:black_jack]
    # check whether the game is done and
    # return the state of the game after this round
    play_done = lambda do
      if black_jack.check_done_conditions == true
        winner = black_jack.detect_winner
        if winner.nil?
          return {:state => 'done', :info => 'no winner'}
        else
          return {:state => 'done', :info => 'winner'}
        end
      end
      {:state => 'running'}
    end

    state = play_done.call
    if state[:state] == 'done'
      return state.to_json
    end

    # let the players draw a card
    name = session[:name]
    answer = params[:answer]

    all = black_jack.players + [black_jack.dealer]
    all.each do |player|
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

  # return the state of the game after this round
  play_done.call.to_json
end

get '/players.json' do
  content_type :json
  if session[:black_jack].nil?
    [].to_json
  else
    black_jack = session[:black_jack]

    winner = nil
    if black_jack.check_done_conditions == true
      winner = black_jack.detect_winner
    end
    hash = black_jack.players.as_hash
    black_jack.players.each_with_index do |p,idx|
      hash[idx][:busted] = p.busted?
      hash[idx][:winner] = !winner.nil? && p.name == winner.name
      hash[idx][:sum] = p.sum
    end
    hash.to_json
  end
end

get '/dealers.json' do
  content_type :json
  if session[:black_jack].nil?
    {}.to_json
  else
    black_jack = session[:black_jack]
    dealer = black_jack.dealer
    hash = dealer.as_hash
    hash[:busted] = dealer.busted?
    hash[:winner] = black_jack.won?(dealer)
    hash[:sum] = dealer.sum
    hash.to_json
  end
end