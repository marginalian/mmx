require "ostruct"

require_relative "../../composable"
require_relative "../../emender"

module Mmx
  class Leaf
    class Convert
      class Markdown
        extend Composable

        def initialize(syntax_tree, nabs)
          @syntax_tree = syntax_tree
          @nabs = nabs
        end

        def call
          syntax_tree
            .reduce("", &method(:translate))
            .then(&method(:format))
        end

        def self.read_more_link(base_file_name)
          "\n\n[read more](#{base_file_name}.markdown)"
        end

        private

        attr_reader :syntax_tree, :nabs

        def translate(markdown_string, tree_entry)
          type = tree_entry[:type]
          arr = tree_entry[:arr]

          if type == :heading
            guide = mapping[:heading].(tree_entry[:lvl])
          else
            guide = mapping[type]
          end

          if !guide[:replace].nil?
            return markdown_string if guide[:replace].empty?

            new_markdown = guide[:replace]
          elsif guide[:wrap]
            new_markdown = arr.map { |el| "#{guide[:wrap]}#{el}#{guide[:wrap]}" }.join("\n\n")
          elsif guide[:pre].nil?
            new_markdown = arr.join("\n\n")
          else
            new_markdown = arr.map { |text| "#{guide[:pre]} #{text}" }.join("\n\n")
          end

          "#{markdown_string}\n\n#{new_markdown}"
        end

        def format(markup)
          markup
            .gsub(/\{\((.*?)\)\}/) { |match| Emender.(match.slice(1..-2), nabs, :markdown)}
            .gsub(/-{2}/, "—")
        end

        def mapping
          {
            paragraph: {},
            heading: -> (lvl) { { pre: "#" * lvl } },
            blockquote: { pre: '>' },
            list: { pre: '-' },
            break: { replace: '___' },
            comment: { wrap: '`' },
            space: { replace: "" },
            code: { wrap: '```' },
          }
        end
      end
    end
  end
end
