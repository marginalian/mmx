require "ostruct"

require_relative "../../composable"
require_relative "../../emender"

module Mmx
  class Leaf
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
          type = tree_entry[:type]
          arr = tree_entry[:arr]

          if type == :heading
            guide = mapping[:heading].(tree_entry[:lvl])
          else
            guide = mapping[type]
          end

          return "#{html_string}#{guide[:html]}" if !guide[:html].nil?
          return html_string if guide[:tag].nil?

          arr = arr.map(&method(guide[:process])) unless guide[:process].nil?
          inner = arr.map { |txt| "#{s(3)}<#{guide[:tag]}>#{txt}</#{guide[:tag]}>" }.join

          if guide[:wrap].nil?
            "#{html_string}#{inner}"
          else
            "#{html_string}<#{guide[:wrap]}>#{inner}</#{guide[:wrap]}>"
          end
        end

        def format(markup)
          markup
            .gsub(/\{\((.*?)\)\}/) { |match| Emender.(match.slice(1..-2), nabs)}
            .gsub(/-{2}/, "&mdash;")
            .gsub(/__(.*?)__/, '<strong>\1</strong>')
            .gsub(/_(.*?)_/, '<em>\1</em>')
            .gsub(/`(.*?)`/, &method(:codify))
            .then { |html| "<div class='leaf'>#{html}#{s(2)}</div>" }
        end

        # TODO: move this into a processors hash
        # fetch from the hash in "wrap" method
        def escape_html(string)
          string
            .gsub("&", "&amp;")
            .gsub("<", "&lt;")
            .gsub(">", "&gt;")
            # do not process emender expressions:
            .gsub("{", "&#123;")
            .gsub("}", "&#125;")
        end

        def codify(match)
          processed_match = match
            .delete_prefix("`")
            .delete_suffix("`")
            .yield_self(&method(:escape_html))

          "<code>#{processed_match}</code>"
        end

        def mapping
          {
            paragraph: { tag: 'p' },
            heading: -> (lvl) { { tag: "h#{lvl}" } },
            blockquote: { tag: 'blockquote' },
            list: { tag: 'li', wrap: 'ul' },
            break: { html: '<hr>' },
            comment: { html: '' },
            space: { html: '' },
            code: { tag: 'div', wrap: 'pre', process: 'escape_html' },
          }
        end

        def s(indent)
          "\n#{"\s" * 2 * indent}"
        end
      end
    end
  end
end

