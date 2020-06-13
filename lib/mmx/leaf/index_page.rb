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
          <<~HTML
            #{leaf.title_html}
            #{leaf.first_paragraph_html}
            <a class='read-more' href='#{leaf.base_file_name}.html'>
              read more
            </a>
          HTML
        end
      end
    end
  end
end
