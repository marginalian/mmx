module Mmx
  class Leaf
    class AllPagesIndex
      include Renderable

      attr_reader :leaves

      def initialize(leaves)
        @leaves = leaves
      end

      def site_file_name
        "all_pages"
      end

      def to_html
        summaries.join
      end

      def config
        leaves.first.chapter.wiki.config
      end

      def show_lower_nav?
        false
      end

      def type
        :all_pages
      end

      private

      def summaries
        leaves.map do |leaf|
          <<~HTML
            <section>
              #{leaf.title_html}
              <div class="sans-serif-text">
                &bull;&nbsp;#{leaf.chapter.name} chapter&nbsp;&bull;&nbsp;
              </div>
              <hr class="marginless" />
              #{leaf.first_paragraph_html}
              <a class='read-more' href='#{leaf.chapter.name}/pages/#{leaf.base_file_name}.html'>
                read more
              </a>
              <br>
            </section>
          HTML
        end
      end
    end
  end
end
