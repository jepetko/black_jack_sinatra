require 'rubygems'
require 'sinatra'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret' 

#set :sessions, true

get '/' do
	erb :index
end

post '/play' do
	puts params['name']
end	