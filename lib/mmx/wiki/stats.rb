module Mmx
  class Wiki
    class Stats
      def initialize(wiki)
        @wiki = wiki
      end

      def notecard_count
        notecards.length
      end

      def page_count
        Dir[File.join(wiki.top_directory, '**', '*')].count(&File.method(:file?))
      end

      private

      attr_reader :wiki

      def notecards
        wiki.chapters.map(&:notecards).flatten
      end

      def pages

        wiki.chapters.map(&:leaves).flatten
      end
    end
  end
end
