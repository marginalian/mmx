module Mmx
  class Leaf
    class Emender
      extend Composable
      extend Forwardable
      def_delegator :@leaf, :context

      def initialize(leaf)
        @leaf = leaf
      end

      def call
        binding
      end

      protected

      def hi(pattern, text)
        text.gsub(pattern) { "<span class='highlight'>#{_1}</span>" }
      end

      def hi_exp(pattern, text)
        text.gsub(Regexp.new(pattern)) { "<span class='highlight'>#{_1}</span>" }
      end

      def img(path)
        <<~HTML
          <div class="img-container">
            <img src="#{path}">
          </div>
        HTML
      end

      def img_size(path, width, height)
        <<~HTML
          <div class="img-container dark">
            <img width="#{width}" height="#{height}" src="#{path}">
          </div>
        HTML
      end

      def indent(text)
        "<div class='indent'>#{text}</div>"
      end

      def link(text, path)
        target = path =~ /^https?:/ ? "_blank" : ""
        href = path.gsub("leaf", "html").gsub("_", "&lowbar;")

        "<a target='#{target}' href='#{href}'>#{text}</a>"
      end

      def long(text)
        "<div class='long'>#{text}</div>"
      end

      def notecard(id)
        notecard = context.notecards.lookup(id)

        <<~HTML
          <div class="attributed-quote">
            #{blockquote(notecard)}
          </div>
        HTML
      end

      def notecard_combine(*notecard_ids)
        notecard_html = notecard_ids
          .map { |id| context.notecards.lookup(id).quote.split("\n\n").join("<br><br>") }
          .join("<br><br>[...]<br><br>")

        <<~HTML
          <div class="attributed-quote">
            <div class="single-blockquote">
              #{notecard_html}
            </div>
          </div>
        HTML
      end

      def notecard_plus(id)
        notecard = context.notecards.lookup(id)

        <<~HTML
          <div class="attributed-quote">
            #{blockquote(notecard) + attribution(notecard)}
          </div>
        HTML
      end

      def notecard_pull(id)
        notecard = context.notecards.lookup(id)

        attribution = "<div class='notecard-source'>&mdash;#{notecard.source} - #{notecard.author}</div>"
        "<div class='pull'><div class='pull-quote'>#{notecard.quote}</div><br>#{attribution}</div>"
      end

      def pull_quote(text)
        "<div class='pull'><div class='pull-quote'>#{text}</div></div>"
      end

      def webring
        <<~HTML
          <div class="webring">
            <a href='https://webring.xxiivv.com/#random' target='_blank'>
              <img src='https://webring.xxiivv.com/icon.black.svg'/>
            </a>
            <br>
            <strong>WEBRING</strong>
          </div>
        HTML
      end

      private

      def attribution(notecard)
        "<div class='notecard-source'>&mdash;&nbsp;#{notecard.source} - #{notecard.author}</div>"
      end

      def blockquote(notecard)
        notecard.quote.split("\n\n").map do |paragraph|
          "<div class='single-blockquote'>#{paragraph}</div>"
        end.join
      end
    end
  end
end
