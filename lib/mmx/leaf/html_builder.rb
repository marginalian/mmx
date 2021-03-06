module Mmx
  class Leaf
    class HtmlBuilder
      extend Composable

      def initialize(leaf, syntax_tree)
        @leaf = leaf
        @syntax_tree = syntax_tree
        @todo_id = 0
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

        if [:todo_checked, :todo_unchecked].include?(type)
          @todo_id = @todo_id + 1
        end

        if type == :heading
          guide = mapping[:heading].(tree_entry[:lvl])
        else
          guide = mapping[type]
        end

        return "#{html_string}#{guide[:html]}" if !guide[:html].nil?
        return html_string if guide[:tag].nil?

        arr = arr.map(&method(guide[:process])) unless guide[:process].nil?
        inner = arr.map do |txt|
          if txt.class == Hash
            next wrap("", txt)
          end

          id = guide[:id].nil? ? "" : guide[:id].(txt)

          "#{s(3)}<#{guide[:tag]} id='#{id}' #{guide[:props]}>#{txt}</#{guide[:tag]}>"
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
          .gsub(/`(.*?)`/, &method(:codify))
          .gsub(/-{2}/, "&mdash;")
          .gsub(/__(.*?)__/, '<strong>\1</strong>')
          .gsub(/_(.*?)_/, '<em>\1</em>')
      end

      # this prevents the #format method from messing with
      # code blocks and renders them verbatim
      def escape_html(string)
        string
          .gsub("&", "&amp;")
          .gsub("<", "&lt;")
          .gsub(">", "&gt;")
          .gsub("_", "&lowbar;")
          .gsub("-", "&#45;")
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
          blockquote: { tag: 'p', wrap: 'blockquote' },
          break: { html: '<br />' },
          ulist: { tag: 'li', wrap: 'ul' },
          olist: { tag: 'li', wrap: 'ol' },
          line: { html: '<hr>' },
          double_line: { html: '<hr class="double">' },
          comment: { html: '' },
          space: { html: '' },
          code: { tag: 'div', wrap: 'pre', process: 'escape_html' },
          todo_checked: { html: "<input disabled type=\"checkbox\" checked id=\"todo-#{@todo_id}\">" },
          todo_unchecked: { html: "<input disabled type=\"checkbox\"  id=\"todo-#{@todo_id}\">" },
          todo_label: { tag: 'label', props: "for=\"todo-#{@todo_id}\"" },
        }
      end

      def s(indent)
        "\n#{"\s" * 2 * indent}"
      end
    end
  end
end
