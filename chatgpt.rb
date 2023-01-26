# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'openai'

class Server
  def initialize
    begin
      @config = JSON.parse(File.read('config.json'))
    rescue Errno::ENOENT => e
      puts "Error: config.json file not found, please check that the file exists in the current directory: #{e.class}"
      exit
    rescue JSON::ParserError => e
      puts "Error: config.json file is not valid JSON, please check the format of the file: #{e.class}"
      exit
    end

    set :bind, @config['server']['ip']
    set :port, @config['server']['port']
  end

  def run
    get '/query' do
      api_key = params[:api_key]
      return { status: 'error', message: 'Invalid API key' }.to_json if api_key != @config['api_key']

      query = params[:query]
      response = OpenAI::Completion.create(
        engine: 'text-davinci-002',
        prompt: query,
        max_tokens: 2048,
        api_key: api_key
      )
      { status: 'ok', data: response.choices.first.text }.to_json
    end

    run!
  end
end
