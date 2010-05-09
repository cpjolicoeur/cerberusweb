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
  attr_accessor :status

  def feed
    return '' unless config && config["publisher"] && config["publisher"]["rss"] && config["publisher"]["rss"]["file"]

    file = config["publisher"]["rss"]["file"]
    if File.exists?(file)
      File.read(file)
    else
      ''
    end
      
  end

  def build_success?
    status && status["successful"]
  end

  def built_at
    status && status["timestamp"]
  end

  def self.find(name)
    return nil unless File.exists?(ENV['HOME'] + "/.cerberus/config/#{name}.yml")

    project = new
    project.name = name
    project.config = YAML.load(File.read(ENV['HOME'] + "/.cerberus/config/#{name}.yml"))
    status_log = ENV['HOME'] + "/.cerberus/work/#{name}/status.log"
    project.status = YAML.load(File.read(status_log)) if File.exists?(status_log)
    project
  end

  def self.load
    project_names = Dir[ENV['HOME'] + '/.cerberus/config/*.yml'].inject([]) do |acc, config_file|
      acc << File.basename(config_file).gsub('.yml','')
    end

    project_names.inject([]) do |acc, name|
      acc << find(name)
    end

  end
end
