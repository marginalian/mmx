module Mmx
  class Renderer
    module Helpers
      extend self

      def index_path(type)
        case type
        when :index, :notecards
          "./index.html"
        else
          "../index.html"
        end
      end

      def pages_path(type)
        case type
        when :index, :notecards
          "./pages/index.html"
        else
          "./index.html"
        end
      end
    end
  end
end

