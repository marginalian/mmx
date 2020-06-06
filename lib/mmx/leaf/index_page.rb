module Mmx
  class Leaf
    class IndexPage
      include Renderable

      attr_reader :chapter, :leaves, :type

      def initialize(leaves)
        @leaves = leaves
        @chapter = leaves.first.chapter
        @type = leaves.last.type
      end

      def site_file_name
        "#{chapter.name}/#{type}/index"
      end

      def to_html
        summaries.join
      end

      private

      def summaries
        leaves.map do |leaf|
          summary = summarize(leaf)
          tree = Leaf::SyntaxTree.(summary)
          html = Leaf::HtmlBuilder.(leaf, tree)

          <<~HTML
            #{html}
            <a class='read-more' href='#{leaf.base_file_name}.html'>
              read more
            </a>
          HTML
        end
      end

      def summarize(leaf)
        leaf
          .content
          .gsub(/^\~+$/, "")
          .gsub(/[a-zA-Z.]\n[a-zA-Z]/) { _1.gsub("\n", "\s") }
          .gsub(/^-$/, "--")
          .split("\n")
          .reject(&:empty?)
          .first(3)
      end
    end
  end
end
