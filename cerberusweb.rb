require 'rubygems'
require 'sinatra'

get '/' do
  @projects = CerberusProject.load
  erb :index
end

get '/server_errors' do
  @error_log = File.read(ENV['HOME'] + '/.cerberus/error.log')
  erb :server_errors
end

class CerberusProject
  attr_accessor :name

  def self.load
    project_names = Dir[ENV['HOME'] + '/.cerberus/config/*.yml'].inject([]) do |acc, config_file|
      acc << File.basename(config_file).gsub('.yml','')
    end

    project_names.inject([]) do |projects, name|
      p = new
      p.name = name
      projects << p
    end
    
  end
end
