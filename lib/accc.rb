require 'zeitwerk'
require 'faraday'
require 'faraday/multipart'
require 'uri'
require 'json'

module ACCC
  module Errors
    class Error < StandardError; end
  end

  module Endpoints; end

  @configuration = nil

  class << self
    attr_accessor :configuration
  end

  def self.configure
    @configuration ||= Configuration.new
    @configuration.client_id = ENV['CLIENT_ID'] if ENV['CLIENT_ID']
    @configuration.client_secret = ENV['CLIENT_SECRET'] if ENV['CLIENT_SECRET']
    yield(@configuration) if block_given?
  end
end

require_relative 'accc/version'
require_relative 'accc/configuration'
require_relative 'accc/errors/access_token_error'
require_relative 'accc/errors/refresh_token_error'
require_relative 'accc/endpoints/response_handler'
require_relative 'accc/endpoints/auth'

# Initialize the loader
loader = Zeitwerk::Loader.for_gem
loader.push_dir("#{__dir__}/accc")
loader.setup
