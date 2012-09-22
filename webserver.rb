# encoding: UTF-8

# Extend the Ruby load path with the root of the API and the lib folder
# so that we can automatically include all our own custom classes. This makes
# the requiring of files a bit cleaner and easier to maintain.
# This is basically what rails does as well.
# We also store the root of the API in the ENV settings to ensure we have
# always access to the root of the API when building paths.
ENV['API_ROOT'] = File.dirname(__FILE__)
$:.unshift ENV['API_ROOT']
$:.unshift File.expand_path(File.join(ENV['API_ROOT'], 'lib'))


require 'sinatra'
require 'lib/rgreek'
require 'lib/transcoder'


get '/parse/:betacode' do |betacode|
   #RGreek::Parse.find_parses_hashed_by_lemma betacode
end