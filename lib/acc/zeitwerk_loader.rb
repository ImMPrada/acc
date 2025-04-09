require 'zeitwerk'

module ACC
  # Configura el cargador de Zeitwerk para autocargar las clases
  module ZeitwerkLoader
    class << self
      def setup
        loader = Zeitwerk::Loader.new
        loader.tag = 'acc'
        loader.push_dir(File.expand_path('..', __dir__))
        loader.ignore("#{File.expand_path('..', __dir__)}/acc.rb")
        loader.setup
        loader
      end
    end
  end
end
