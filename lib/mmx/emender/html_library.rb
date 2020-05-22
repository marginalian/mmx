module Mmx
  class Emender
    HTML_LIBRARY = {
      hi: -> (pattern, text, nabs:) do
        text.gsub(pattern) { "<span class='highlight'>#{_1}</span>" }
      end,

      'hi-exp': -> (pattern, text, nabs:) do
        text.gsub(Regexp.new(pattern)) { "<span class='highlight'>#{_1}</span>" }
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
        attribution = "<div class='nab-source'>#{nab.source} - #{nab.author}</div>"
        "<blockquote class='pull-quote'>#{nab.quote}</blockquote>#{attribution}"
      end,

      'pull-quote': -> (text, nabs:) do
        "<blockquote class='pull-quote'>#{text}</blockquote>"
      end,
    }
  end
end
