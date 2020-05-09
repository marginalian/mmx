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

        "<a target='#{target}' href='#{path.gsub("leaf", "html")}'>#{text}</a>"
      end,

      long: -> (text, nabs:) do
        "<div class='long'>#{text}</div>"
      end,

      nab: -> (id, nabs:) do
        nabs.lookup(id).quote.split("\n\n").map { "<blockquote>#{_1}</blockquote>" }.join
      end,

      'nab-plus': -> (id, nabs:) do
        nab = nabs.lookup(id)
        block = nab.quote.split("\n\n").map { "<blockquote>#{_1}</blockquote>" }.join
        attribution = "<div class='nab-source'>#{nab.source} - #{nab.author}</div>"
        block + attribution
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
