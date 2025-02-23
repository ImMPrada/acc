require 'faraday'
require 'faraday/multipart'
require 'uri'
require 'json'

module ACCC
  module Errors
    class AuthError < StandardError; end
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

# Load base files first
require_relative 'accc/version'
require_relative 'accc/configuration'

# Load modules/dependencies first
require_relative 'accc/endpoints/response_handler'

# Load error classes
Dir.glob(File.join(__dir__, 'accc', 'errors', '*.rb')).sort.each do |file|
  require_relative file.sub("#{__dir__}/", '')
end

# Load endpoints last
Dir.glob(File.join(__dir__, 'accc', 'endpoints', '*.rb')).sort.each do |file|
  next if file.end_with?('response_handler.rb') # Skip already loaded

  require_relative file.sub("#{__dir__}/", '')
end
