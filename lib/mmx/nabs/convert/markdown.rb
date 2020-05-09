require "erb"

require_relative "../../composable"

module Mmx
  class Nabs < Array
    class Convert
      class Markdown
        extend Composable

        def initialize(nabs)
          @nabs = nabs
        end

        def call
          nabs.reduce("", &method(:notecardify)).gsub(/-{2}/, "&mdash;")
        end

        private

        attr_reader :nabs

        def notecardify(notecards, nab)
          notecards + ERB.new(notecard_template).result(nab.get_binding)
        end

        def notecard_template
          template_path = "#{__dir__}/../../templates/notecard.markdown.erb"
          File.open(template_path, "rb", encoding: 'utf-8', &:read)
        end
      end
    end
  end
end
