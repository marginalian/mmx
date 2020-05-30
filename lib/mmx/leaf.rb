module Mmx
  class Leaf
    include Renderable

    attr_reader :chapter, :content, :type

    def initialize(chapter, path, type = :index)
      @chapter = chapter
      @path = path
      @type = type
      @file_config, @content = extract_config
    end

    def base_file_name
      path.split("/").last.sub(/\..*/, '')
    end

    def site_file_name
      base = type == :index ? base_file_name : "#{type}/#{base_file_name}"
      "#{chapter.name}/#{base}"
    end

    def file_content
      @file_content ||=
        File.open(path, "rb").read.force_encoding('UTF-8')
    end

    def file_content_lines
      content.split("\n")
    end

    def syntax_tree
      SyntaxTree.(file_content_lines)
    end

    def to_html
      HtmlBuilder.(self, syntax_tree)
    end

    def context
      @context ||= begin
        OpenStruct.new({
          notecards: chapter.notecards,
          stats: chapter.wiki.stats,
        })
      end
    end

    def show_lower_nav?
      chapter.pages&.length&.positive?
    end

    def config
      chapter.wiki.config.merge(file_config)
    end

    private

    attr_reader :file_config

    def extract_config
      ConfigExtractor.(file_content)
    end

    attr_reader :path
  end
end

