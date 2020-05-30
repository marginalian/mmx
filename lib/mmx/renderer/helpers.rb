module Mmx
  class Renderer
    module Helpers
      extend self

      def stylesheet_path(type)
        case type
        when :index, :notecards
          "../../mmx/styles/main.css"
        else
          "../../../mmx/styles/main.css"
        end
      end

      def core_path(type)
        case type
        when :index, :notecards
          "../../index.html"
        else
          "../../../index.html"
        end
      end

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

      def root_path(type)
        case type
        when :index, :notecards
          "../.."
        else
          "../../.."
        end
      end
    end
  end
end

