require 'rubygems'
require 'sinatra'

require 'yaml'

get '/' do
  @projects = CerberusProject.load
  erb :index
end

get '/projects/:project_name/feed' do
  @project = CerberusProject.find(params[:project_name])
  @project.feed
end

get '/server_errors' do
  @error_log = File.read(ENV['HOME'] + '/.cerberus/error.log')
  erb :server_errors
end

class CerberusProject
  attr_accessor :name
  attr_accessor :config

  def feed
    return '' unless config && config["publisher"] && config["publisher"]["rss"] && config["publisher"]["rss"]["file"]

    file = config["publisher"]["rss"]["file"]
    if File.exists?(file)
      File.read(file)
    else
      ''
    end
      
  end

  def self.find(name)
    return nil unless File.exists?(ENV['HOME'] + "/.cerberus/config/#{name}.yml")

    project = new
    project.name = name
    project.config = YAML.load(File.read(ENV['HOME'] + "/.cerberus/config/#{name}.yml"))
    project
  end

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
