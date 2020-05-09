require "erb"

require_relative "../composable"

module Mmx
  class Project
    class RenderPage
      extend Composable

      def initialize(type, body, output_format, show_nav = true)
        @type = type
        @body = body
        @output_format = output_format
        @show_nav = show_nav
      end

      def call
        ERB.new(template).result(binding)
      end

      def brand
        $config&.site_name || "brand"
      end

      def description
        $config&.description || ""
      end

      def keywords
        $config&.keywords || ""
      end

      def stylesheet_path
        case type
        when :index
          "../../styles/base.css"
        when :page
          "../../../styles/base.css"
        end
      end

      def core_path
        case type
        when :index
          "../../index.#{output_format}"
        when :page
          "../../../index.#{output_format}"
        end
      end

      def index_path
        case type
        when :index
          "./index.#{output_format}"
        when :page
          "../index.#{output_format}"
        end
      end

      def pages_path
        case type
        when :index
          "./pages/index.#{output_format}"
        when :page
          "./index.#{output_format}"
        end
      end

      private

      attr_reader :type, :output_format

      def template
        template_path = "#{__dir__}/../templates/page.#{output_format}.erb"
        File.open(template_path, "rb", encoding: 'utf-8', &:read)
      end
    end
  end
end
