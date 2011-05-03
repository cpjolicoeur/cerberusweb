require 'rubygems'
require 'sinatra'

set :env, :production
disable :run

require File.expand_path( File.join( File.dirname(__FILE__), 'cerberusweb' ) )
run Sinatra::Application
