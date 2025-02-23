require 'faraday'
require 'faraday/multipart'
require 'uri'
require 'json'

# Load base files first
require_relative 'accc/version'
require_relative 'accc/configuration'

# Load error classes
require_relative 'accc/errors/auth_error'
Dir.glob(File.join(__dir__, 'accc', 'errors', '*.rb')).each do |file|
  next if file.end_with?('auth_error.rb') # Skip already loaded

  require_relative file.sub("#{__dir__}/", '')
end

# Load modules/dependencies first
require_relative 'accc/endpoints/response_handler'

# Load endpoints last
Dir.glob(File.join(__dir__, 'accc', 'endpoints', '*.rb')).each do |file|
  next if file.end_with?('response_handler.rb') # Skip already loaded

  require_relative file.sub("#{__dir__}/", '')
end

module ACCC
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
