module Mmx
  class Wiki
    attr_reader :top_directory

    def initialize(top_directory)
      @top_directory = top_directory
    end

    def chapters
      @chapters ||=
        Dir.glob("#{top_directory}/*/").map { |dir| Chapter.new(self, dir) }
    end

    def config
      @config ||=
        default_config.merge(Utils.read_yaml(CONFIG_PATH))
    end

    def default_config
      {
        "font_type" => "serif",
      }
    end

    def stats
      @stats ||=
        Stats.new(self)
    end

    def all_pages
      chapters.map(&:leaves).flatten(1).push(all_pages_index)
    end

    def all_pages_index
      sorted_pages = chapters.map(&:pages).compact.flatten(1).sort_by(&:base_file_name).reverse
      Leaf::AllPagesIndex.new(sorted_pages)
    end

    def all_notecards
      chapters.map(&:notecards).flatten(1)
    end

    private

    CONFIG_PATH = "#{__dir__}/../../../config.yml"
    private_constant :CONFIG_PATH
  end
end

