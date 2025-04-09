require 'faraday'
require 'faraday/multipart'
require 'uri'
require 'json'

# Carga el cargador de Zeitwerk
require_relative 'acc/zeitwerk_loader'

# Cargar archivos base explícitamente
require_relative 'acc/version'
require_relative 'acc/configuration'
require_relative 'acc/errors'

# Cargar módulos principales
require_relative 'acc/http/response_handler'
require_relative 'acc/http/client'
require_relative 'acc/utils/paginated'
require_relative 'acc/clients/base'
require_relative 'acc/clients'
require_relative 'acc/clients/auth'
require_relative 'acc/clients/construction_cloud/base'
require_relative 'acc/clients/construction_cloud/issues/index'
require_relative 'acc/clients/construction_cloud/issues/me'

# Configura Zeitwerk para autocargar el resto de las clases
ACC::ZeitwerkLoader.setup

module ACC
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
