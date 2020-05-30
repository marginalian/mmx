module Mmx
  class Wiki
    def initialize(top_directory)
      @top_directory = top_directory
    end

    def chapters
      @chapters ||=
        Dir.glob("#{top_directory}/*/").map { |dir| Chapter.new(self, dir) }
    end

    def config
      @config ||=
        Utils.read_yaml(CONFIG_PATH)
    end

    def stats
      @stats ||=
        Stats.new(self)
    end

    def all_pages
      chapters.map(&:leaves).flatten(1)
    end

    def all_notecards
      chapters.map(&:notecards).flatten(1)
    end

    private

    CONFIG_PATH = "#{__dir__}/../../../config.yml"
    private_constant :CONFIG_PATH

    attr_reader :top_directory
  end
end

