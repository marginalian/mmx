require_relative "../composable"
require_relative "./render_page"
require_relative "./render_notecards"
require_relative "./site_struct"

module Mmx
  class Project
    class Convert
      extend Composable

      def initialize(project, output_format)
        @project = project
        @output_format = output_format
      end

      def call
        create_site
        build_index
        build_pages
        build_pages_index
        build_drafts
        build_drafts_index
        build_notecards
        build_words
      end

      private

      attr_reader :project, :output_format

      def site_struct
        SiteStruct.(project, output_format)
      end

      def create_site
        try_mkdir(root_path)
        try_mkdir("#{root_path}/#{project.name}")
        try_mkdir("#{root_path}/#{project.name}/pages")
        try_mkdir("#{root_path}/#{project.name}/drafts")
      end

      def try_mkdir(path)
        Dir.mkdir(path) unless File.exists?(path)
      end

      def build_index
        show_nav = site_struct.pages.any?

        File.write(
          "#{root_path}/#{project.name}/index.#{output_format}",
          RenderPage.(:index, site_struct.index, output_format, show_nav),
        )
      end

      def build_pages
        return unless pages?

        site_struct.pages.each do |file_name, content|
          File.write(
            "#{root_path}/#{project.name}/pages/#{file_name}.#{output_format}",
            RenderPage.(:page, content, output_format),
          )
        end
      end

      def build_drafts
        return unless drafts?

        site_struct.drafts.each do |file_name, content|
          File.write(
            "#{root_path}/#{project.name}/drafts/#{file_name}.#{output_format}",
            RenderPage.(:page, content, output_format),
          )
        end
      end

      def build_pages_index
        return unless pages?

        File.write(
          "#{root_path}/#{project.name}/pages/index.#{output_format}",
          RenderPage.(:page, site_struct.pages_index, output_format),
        )
      end

      def build_drafts_index
        return unless drafts?

        File.write(
          "#{root_path}/#{project.name}/drafts/index.#{output_format}",
          RenderPage.(:page, site_struct.drafts_index, output_format),
        )
      end

      def build_notecards
        return unless project.nabs.length.positive?

        File.write(
          "#{root_path}/#{project.name}/notecards.#{output_format}",
          RenderNotecards.(site_struct.notecards, output_format, project.nabs),
        )
      end

      def build_words
        return unless site_struct.words

        File.write(
          "#{root_path}/#{project.name}/words.#{output_format}",
          RenderPage.(:index, site_struct.words, output_format),
        )
      end

      def root_path
        case output_format
        when :html
          "site"
        when :markdown
          "site-md"
        end
      end

      def drafts?
        site_struct.drafts.length.positive?
      end

      def pages?
        site_struct.pages.length.positive?
      end
    end
  end
end
