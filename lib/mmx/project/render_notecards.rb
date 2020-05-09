require "erb"
require "date"

require_relative "../composable"

module Mmx
  class Project
    class RenderNotecards
      extend Composable

      def initialize(body, output_format, nabs)
        @body = body
        @output_format = output_format
        @nabs = nabs
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
        "../../styles/base.css"
      end

      def core_path
        "../../index.#{output_format}"
      end

      def index_path
        "./index.#{output_format}"
      end

      def pages_path
        "./pages/index.#{output_format}"
      end

      def nab_count
        nabs.length
      end

      def first_nab_at
        return unless nabs.map(&:id).min

        DateTime.strptime(nabs.map(&:id).min,'%s').to_date.to_s
      end

      def last_nab_at
        return unless nabs.map(&:id).min

        DateTime.strptime(nabs.map(&:id).max,'%s').to_date.to_s
      end

      private

      attr_reader :output_format, :nabs

      def template
        template_path = "#{__dir__}/../templates/notecards.#{output_format}.erb"
        File.open(template_path, "rb", encoding: 'utf-8', &:read)
      end
    end
  end
end
