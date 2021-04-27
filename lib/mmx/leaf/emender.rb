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

      def editorialize(comment, notecard_id)
        notecard = context.notecards.lookup(notecard_id)

        <<~HTML
          <div class="attributed-quote">
            <div class="single-blockquote">
              [#{comment}]
            </div>

            #{blockquote(notecard) + attribution(notecard)}
          </div>
        HTML
      end

      def hi(pattern, text)
        text.gsub(pattern) { |m| "<span class='highlight'>#{m}</span>" }
      end

      def hi_exp(pattern, text)
        text.gsub(Regexp.new(pattern)) { |m| "<span class='highlight'>#{m}</span>" }
      end

      def img(path, attribution=nil)
        <<~HTML
          <figure class="img-container">
            <img src="#{path}">
            <figcaption>#{attribution}</figcaption>
          </figure>
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
        mod_class = notecard.quote.chars.length > 100 ? " long" : ""

        "<div class='pull'><div class='pull-quote#{mod_class}'>#{notecard.quote}</div>#{attribution(notecard)}</div>"
      end

      def pull_quote(text)
        "<div class='pull'><div class='pull-quote'>#{text}</div></div>"
      end

      def stats(name)
        context.stats.send(name)
      end

      def top
        <<~HTML
          <a href='#top' class='top-link'>
            &utri;&nbsp;&nbsp;back to top
          </a>
        HTML
      end

      def webring
        <<~HTML
          <div class="webring">
            <a href='https://webring.xxiivv.com/#random' target='_blank'>
              <img src='https://webring.xxiivv.com/icon.black.svg'/>
            </a>
            Margin Chronicles participates in a webring of non-commercial websites.
          </div>
        HTML
      end

      private

      def attribution(notecard)
        "<div class='notecard-source'>&nbsp;#{notecard.source} - #{notecard.author}</div>"
      end

      def blockquote(notecard)
        notecard.quote.split("\n\n").map do |paragraph|
          "<div class='single-blockquote'>#{paragraph}</div>"
        end.join
      end
    end
  end
end
