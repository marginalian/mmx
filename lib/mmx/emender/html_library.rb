module Mmx
  class Emender
    HTML_LIBRARY = {
      hi: -> (pattern, text, nabs:) do
        text.gsub(pattern) { "<span class='highlight'>#{_1}</span>" }
      end,

      'hi-exp': -> (pattern, text, nabs:) do
        text.gsub(Regexp.new(pattern)) { "<span class='highlight'>#{_1}</span>" }
      end,

      img: -> (path, nabs:) do
        <<~HTML
          <div class="img-container">
            <img src=\"#{path}\">
          </div>
        HTML
      end,

      "img-size": -> (path, width, height, nabs:) do
        <<~HTML
          <div class="img-container dark">
            <img width="#{width}" height="#{height}" src="#{path}">
          </div>
        HTML
      end,

      indent: -> (text, nabs:) do
        "<div class='indent'>#{text}</div>"
      end,

      link: -> (text, path, nabs:) do
        target = path =~ /^https?:/ ? "_blank" : ""
        href = path.gsub("leaf", "html").gsub("_", "&lowbar;")

        "<a target='#{target}' href='#{href}'>#{text}</a>"
      end,

      long: -> (text, nabs:) do
        "<div class='long'>#{text}</div>"
      end,

      nab: -> (id, nabs:) do
        nab_html = nabs.lookup(id).quote.split("\n\n").map { "<div class=\"single-blockquote\">#{_1}</div>" }.join

        <<~HTML
          <div class="attributed-quote">
            #{nab_html}
          </div>
        HTML
      end,

      'nab-plus': -> (id, nabs:) do
        nab = nabs.lookup(id)
        block = nab.quote.split("\n\n").map { "<div class=\"single-blockquote\">#{_1}</div>" }.join
        attribution = "<div class='nab-source'>&mdash;&nbsp;#{nab.source} - #{nab.author}</div>"
        block + attribution

        <<~HTML
          <div class="attributed-quote">
            #{block + attribution}
          </div>
        HTML
      end,

      'nab-pull': -> (id, nabs:) do
        nab = nabs.lookup(id)
        attribution = "<div class='nab-source'>&mdash;#{nab.source} - #{nab.author}</div>"
        "<div class='pull'><div class='pull-quote'>#{nab.quote}</div><br>#{attribution}</div>"
      end,

      'nab-combine': -> (*nab_ids, nabs:) do
        nab_html = nab_ids
          .map { |id| nabs.lookup(id).quote.split("\n\n").join("<br><br>") }
          .join("<br><br>[...]<br><br>")

        <<~HTML
          <div class="attributed-quote">
            <div class="single-blockquote">
              #{nab_html}
            </div>
          </div>
        HTML
    end,

      'pull-quote': -> (text, nabs:) do
        "<div class='pull'><div class='pull-quote'>#{text}</div></div>"
      end,
    }
  end
end
