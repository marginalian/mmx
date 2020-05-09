require_relative "topo/syntax_tree"
require_relative "topo/convert"

module Mmx
  class Topo
    attr_reader :path, :nabs

    def initialize(path, nabs)
      @path = path
      @nabs = nabs
    end

    def file_content
      File.open(path, "rb").read
    end

    def file_content_lines
      file_content.split("\n")
    end

    def base_file_name
      path.split("/").last.sub(/\..*/, '')
    end

    def syntax_tree
      SyntaxTree.(file_content_lines)
    end

    def syntax_tree_summary
      SyntaxTree.(file_content_lines.first(2))
    end

    def convert(output_format)
      self.class.converter_class(output_format).(syntax_tree, nabs)
    end

    # grepability:
    # - Mmx::Topo::Convert::Html
    # - Mmx::Topo::Convert::Markdown
    # - Mmx::Topo::Convert::Leaf
    def self.converter_class(output_format)
      Object.const_get("Mmx::Topo::Convert::#{output_format.capitalize}")
    rescue
      throw "Cannot find topo converter class for format: #{output_format}"
    end
  end
end
