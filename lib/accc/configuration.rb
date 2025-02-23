module ACCC
  class Configuration
    attr_accessor :api_key, :base_url

    def initialize
      @base_url = "https://developer.api.autodesk.com"
    end
  end
end 