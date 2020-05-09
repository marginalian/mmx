require "fileutils"

require_relative "./composable"
require_relative "./nab"
require_relative "./nabs"
require_relative "project/validate"
require_relative "project/convert"

module Mmx
  class Project
    extend Composable

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def call
      self
    end

    def name
      path.split("/").last
    end

    def nabs
      return Nabs.new([]) unless File.exist?(nab_path)

      Nab.parse(File.read(nab_path))
    end

    def valid?
      Validate.(path)
    end

    def convert
      Convert.(self, :html) unless $config&.skip_html
      Convert.(self, :markdown) unless $config&.skip_markdown
    end

    private

    def nab_path
      "#{path}notecards.nab"
    end
  end
end

