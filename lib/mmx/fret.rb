require_relative "./composable"
require_relative "./fret/topo"
require_relative "./fret/nab"

module Mmx
  class Fret
    extend Composable

    def initialize(path)
      @path = path
    end

    def call
      topo_validations + nab_validations
    end

    private

    attr_reader :path

    def topo_validations
      find_files("topo").map(&Fret::Topo)
    end

    def nab_validations
      find_files("nab").map(&Fret::Nab)
    end

    def find_files(ext)
      Dir.glob(File.join(path, "**", "*.#{ext}"))
    end
  end
end
