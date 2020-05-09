require "erb"

require_relative "../../composable"

module Mmx
  class Nabs < Array
    class Convert
      class Html
        extend Composable

        def initialize(nabs)
          @nabs = nabs
        end

        def call
          nabs
            .reduce("", &method(:notecardify))
            .gsub(/-{2}/, "&mdash;")
            .gsub(/__(.*?)__/, '<strong>\1</strong>')
            .gsub(/_(.*?)_/, '<em>\1</em>')
        end

        private

        attr_reader :nabs

        def notecardify(notecards, nab)
          notecards + ERB.new(notecard_template).result(nab.get_binding)
        end

        def notecard_template
          template_path = "#{__dir__}/../../templates/notecard.html.erb"
          File.open(template_path, "rb", encoding: 'utf-8', &:read)
        end
      end
    end
  end
end
