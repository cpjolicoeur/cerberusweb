require 'rubygems'
require 'sinatra'

get '/' do
  @projects = parse_cerberus_list
  erb :index
end

get '/server_errors' do
  @error_log = File.read(ENV['HOME'] + '/.cerberus/error.log')
  erb :server_errors
end

def parse_cerberus_list
  Dir[ENV['HOME'] + '/.cerberus/config/*.yml'].inject([]) do |projects, config_file|
    projects << File.basename(config_file).gsub('.yml','')
  end.sort

end
