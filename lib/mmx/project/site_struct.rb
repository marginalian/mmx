require "ostruct"
require "forwardable"

require_relative "../composable"
require_relative "../leaf"

module Mmx
  class Project
    class SiteStruct
      extend Composable
      extend Forwardable

      def initialize(project, output_format)
        @project = project
        @output_format = output_format
      end

      def call
        OpenStruct.new({
          index: index,
          pages: pages,
          drafts: drafts,
          pages_index: pages_index,
          drafts_index: drafts_index,
          notecards: project.nabs&.convert(output_format) || [],
          words: words,
        })
      end

      private

      attr_reader :project, :output_format
      def_delegators :project, :path, :nabs

      def index
        Leaf.new("#{path}index.leaf", nabs).convert(output_format)
      end

      def pages
        return [] unless pages?

        page_leaves.map(&to_conversion_format).to_h
      end

      def drafts
        return [] unless drafts?

        draft_leaves.map(&to_conversion_format).to_h
      end

      def pages_index
        return unless pages?

        page_leaves.reduce("", &indexify)
      end

      def drafts_index
        return unless drafts?

        draft_leaves.reduce("", &indexify)
      end

      def to_conversion_format
        lambda do |leaf|
          [leaf.base_file_name, leaf.convert(output_format)]
        end
      end

      def indexify
        lambda do |html, leaf|
          converter_class = Leaf.converter_class(output_format)
          summary = converter_class.(leaf.syntax_tree_summary, nabs)
          link = converter_class.read_more_link(leaf.base_file_name)
          html + "#{summary}\n#{link}\n\n\n"
        end
      end

      def page_leaves
        return unless pages?

        @page_leaves ||= collected_leaves("pages")
      end

      def draft_leaves
        return unless drafts?

        @draft_leaves ||= collected_leaves("drafts")
      end

      def collected_leaves(dir)
        Dir.children("#{path}#{dir}/")
          .map { |base| Leaf.new("#{path}#{dir}/#{base}", nabs) }
          .sort_by(&:base_file_name)
          .reverse
      end

      def words
        if File.exist?("#{path}words.leaf")
          Leaf.new("#{path}words.leaf", nabs).convert(output_format)
        end
      end

      private

      def pages?
        File.exist?("#{path}pages/")
      end

      def drafts?
        File.exist?("#{path}drafts/")
      end
    end
  end
end
