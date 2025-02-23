module ACC
  module Resources
    def self.configuration
      ACC.configuration
    end

    def self.configure(&)
      ACC.configure(&)
    end

    def self.version
      ACC::VERSION
    end
  end
end
