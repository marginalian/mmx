module Mmx
  class Emender
    MARKDOWN_LIBRARY = {
      hi: -> (pattern, text, nabs:) do
        text.gsub(pattern) { "***#{_1}***" }
      end,

      'hi-exp': -> (pattern, text, nabs:) do
        text.gsub(Regexp.new(pattern)) { "***#{_1}***" }
      end,

      indent: -> (text, nabs:) { text },

      link: -> (text, path, nabs:) do
        "[#{text}](#{path.gsub("leaf", "markdown")})"
      end,

      long: -> (text, nabs:) { text },

      nab: -> (id, nabs:) do
        nabs.lookup(id)
          .quote
          .split("\n\n")
          .map { "> #{_1}" }
          .join("\n>\n")
          .then { "\n#{_1}" }
      end,

      'nab-plus': -> (id, nabs:) do
        nab = nabs.lookup(id)
        block = nab.quote.split("\n\n").map { "> #{_1}" }.join("\n>\n")
        "\n#{block}\n>\n> --__#{nab.source}__ - #{nab.author}"
      end,

      'nab-pull': -> (id, nabs:) do
        nab = nabs.lookup(id)
        "\n> #{nab.quote}\n>\n> --__#{nab.source}__ - #{nab.author}"
      end,

      'pull-quote': -> (text, nabs:) do
        "\n>___ #{nab.quote}___"
      end,
    }
  end
end
