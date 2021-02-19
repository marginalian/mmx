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

    def title_html
      HtmlBuilder.(self, two_limb_tree[0..0])
    end

    def first_paragraph_html
      HtmlBuilder.(self, two_limb_tree[1..1])
    end

    ##
    # syntax tree for the first two usable lines:
    # - title
    # - paragraph 1
    def two_limb_tree
      Leaf::SyntaxTree.(
        content
          .gsub(/^\~+$/, "")
          .gsub(/[a-zA-Z.]\n[a-zA-Z]/) { |ln| ln.gsub("\n", "\s") }
          .gsub(/^-$/, "--")
          .split("\n")
          .reject(&:empty?)
          .reject { |line| line[/^\<\%/] }
          .first(3)
      )
    end

    private

    attr_reader :file_config, :path

    def extract_config
      ConfigExtractor.(file_content)
    end
  end
end

