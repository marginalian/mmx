require_relative "./leaf/syntax_tree"
require_relative "./leaf/convert"

module Mmx
  class Leaf

    attr_reader :path, :nabs

    def initialize(path, nabs)
      @path = path
      @nabs = nabs
    end

    def base_file_name
      path.split("/").last.sub(/\..*/, '')
    end

    def file_content
      File.open(path, "rb").read.force_encoding('UTF-8')
    end

    def file_content_lines
      file_content.split("\n")
    end

    def file_summary_lines
      file_content
        .gsub(/[a-zA-Z.]\n[a-zA-Z]/) { _1.gsub("\n", "\s") }
        .split("\n")
        .reject(&:empty?)
        .first(3)
    end

    def syntax_tree
      SyntaxTree.(file_content_lines)
    end

    def syntax_tree_summary
      SyntaxTree.(file_summary_lines)
    end

    def convert(output_format)
      self.class.converter_class(output_format).(syntax_tree, nabs)
    end

    # grepability:
    # - Mmx::Leaf::Convert::Html
    # - Mmx::Leaf::Convert::Markdown
    def self.converter_class(output_format)
      Object.const_get("Mmx::Leaf::Convert::#{output_format.capitalize}")
    rescue
      throw "Cannot find leaf converter class for format: #{output_format}"
    end
  end
end
