require 'zeitwerk'
require 'faraday'
require 'faraday/multipart'

module ACCC
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  # Initialize the loader
  loader = Zeitwerk::Loader.for_gem
  loader.setup
end

require 'accc/version'
