require 'rubygems'
require 'sinatra'

set :env, :production
disable :run

require 'cerberusweb'
run Sinatra::Application
