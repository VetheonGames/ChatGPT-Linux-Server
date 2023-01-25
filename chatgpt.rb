# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'openai'

config = JSON.parse(File.read('config.json'))

set :bind, config['server']['ip']
set :port, config['server']['port']

get '/query' do
  query = params[:query]
  api_key = params[:api_key]
  response = OpenAI::Completion.create(
    engine: 'text-davinci-002',
    prompt: query,
    max_tokens: 2048,
    api_key: api_key
  )
  response.choices.first.text
end

run!
