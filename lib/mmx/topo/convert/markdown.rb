require "ostruct"

require_relative "../../composable"
require_relative "../../emender"

module Mmx
  class Topo
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
          case tree_entry
          in prefix:, arr:
            guide = mapping[prefix.to_sym]

            if !guide[:replace].nil?
              new_markdown = guide[:replace]
            elsif guide[:wrap]
              new_markdown = arr.map { |el| "#{guide[:wrap]}#{el}#{guide[:wrap]}" }.join("\n\n")
            elsif guide[:pre].nil?
              new_markdown = arr.join("\n\n")
            else
              new_markdown = arr.map { |text| "#{guide[:pre]} #{text}" }.join("\n\n")
            end

            "#{markdown_string}\n\n#{new_markdown}"
          else
            raise "Failed to wrap #{tree_entry} while converting topo to markdown"
          end
        end

        def format(markup)
          markup
            .gsub(/\{\((.*?)\)\}/) { |match| Emender.(match.slice(1..-2), nabs, :markdown)}
            .gsub(/-{2}/, "—")
        end

        def mapping
          {
            '.': {},
            '-': { pre: '#' },
            '=': { pre: '##' },
            '|': { pre: '>' },
            '+': { pre: '-' },
            '_': { replace: '___' },
            '/': { wrap: '`' },
          }
        end
      end
    end
  end
end
