require 'zeitwerk'
require 'faraday'
require 'faraday/multipart'
require_relative 'accc/configuration'

module ACCC
  class Error < StandardError; end

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

  # Initialize the loader
  loader = Zeitwerk::Loader.for_gem
  loader.setup
end

require 'accc/version'
