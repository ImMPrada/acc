module ACC
  class Configuration
    attr_accessor :client_id, :client_secret, :callback_url, :base_url, :scope

    def initialize
      @base_url = 'https://developer.api.autodesk.com'
    end
  end
end
