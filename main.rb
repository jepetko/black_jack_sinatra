require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'lib/src/black_jack.rb'
require_relative 'lib/src/black_jack_interactive_adapter.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'
#set :sessions, true

#######################################

get '/' do
	erb :index
end

post '/play' do
  black_jack = BlackJack.new
  session[:black_jack] = black_jack
  session[:black_jack].start
	erb :play
end

get '/players.json' do
  content_type :json
  if session[:black_jack].nil?
    [].to_json
  else
    session[:black_jack].players.to_json
  end
end