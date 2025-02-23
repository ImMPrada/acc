module ACCC
  class Configuration
    attr_accessor :client_id, :client_secret, :base_url

    def initialize
      @base_url = 'https://developer.api.autodesk.com'
    end
  end
end
