require "ostruct"

require_relative "../../composable"
require_relative "../../emender"

module Mmx
  class Topo
    class Convert
      class Html
        extend Composable

        def initialize(syntax_tree, nabs)
          @syntax_tree = syntax_tree
          @nabs = nabs
        end

        def call
          syntax_tree
            .reduce("", &method(:wrap))
            .then(&method(:format))
        end

        def self.read_more_link(base_file_name)
          "<a class='read-more' href='#{base_file_name}.html'>read more</a>"
        end

        private

        attr_reader :syntax_tree, :nabs

        def wrap(html_string, tree_entry)
          case tree_entry
          in prefix:, arr:
            guide = mapping[prefix.to_sym]
            return "#{html_string}#{guide[:html]}" if !guide[:html].nil?
            return html_string if guide[:tag].nil?

            inner = arr.map { |txt| "#{s(3)}<#{guide[:tag]}>#{txt}</#{guide[:tag]}>" }.join

            if guide[:wrap].nil?
              "#{html_string}#{inner}"
            else
              "#{html_string}<#{guide[:wrap]}>#{inner}</#{guide[:wrap]}>"
            end
          else
            raise "Failed to wrap #{tree_entry} while converting topo to html"
          end
        end

        def format(markup)
          markup
            .gsub(/\{\((.*?)\)\}/) { |match| Emender.(match.slice(1..-2), nabs)}
            .gsub(/-{2}/, "&mdash;")
            .gsub(/__(.*?)__/, '<strong>\1</strong>')
            .gsub(/_(.*?)_/, '<em>\1</em>')
            .then { |html| "<div class='topo'>#{html}#{s(2)}</div>" }
        end

        def mapping
          {
            '.': { tag: 'p' },
            '-': { tag: 'h1' },
            '=': { tag: 'h2' },
            '|': { tag: 'blockquote' },
            '+': { tag: 'li', wrap: 'ul' },
            '_': { html: '<hr>' },
            '/': { html: '' },
          }
        end

        def s(indent)
          "\n#{"\s" * 2 * indent}"
        end
      end
    end
  end
end
