module Mmx
  class Leaf
    class HtmlBuilder
      extend Composable

      def initialize(leaf, syntax_tree)
        @leaf = leaf
        @syntax_tree = syntax_tree
      end

      def call
        return "" if syntax_tree.nil?

        syntax_tree
          .reduce("", &method(:wrap))
          .then(&method(:format))
      end

      def self.read_more_link(base_file_name)
        "<a class='read-more' href='#{base_file_name}.html'>read more</a>"
      end

      private

      attr_reader :leaf, :syntax_tree

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
        inner = arr.map do |txt|
          id = guide[:id].nil? ? "" : guide[:id].(txt)

          "#{s(3)}<#{guide[:tag]} id='#{id}'>#{txt}</#{guide[:tag]}>"
        end.join

        if guide[:wrap].nil?
          "#{html_string}#{inner}"
        else
          "#{html_string}<#{guide[:wrap]}>#{inner}</#{guide[:wrap]}>"
        end
      end

      def format(markup)
        markup
          .then { |string| ERB.new(string).result(Emender.(leaf)) }
          .gsub(/-{2}/, "&mdash;")
          .gsub(/__(.*?)__/, '<strong>\1</strong>')
          .gsub(/_(.*?)_/, '<em>\1</em>')
          .gsub(/`(.*?)`/, &method(:codify))
      end

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
          heading: -> (lvl) do { tag: "h#{lvl}", id: -> (txt) { txt.downcase.gsub("\s", "&#95;") } } end,
          blockquote: { tag: 'blockquote' },
          break: { html: '<br />' },
          list: { tag: 'li', wrap: 'ul' },
          line: { html: '<hr>' },
          double_line: { html: '<hr class="double">' },
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
