require_relative '../composable'

module Mmx
  class Project
    class Validate
      extend Composable

      def initialize(project_path)
        @project_path = project_path
      end

      def call
        leaf_index? && valid_pages? && valid_drafts?
      end

      private

      attr_accessor :project_path

      def leaf_index?
        Dir.children(project_path).include?('index.leaf')
      end

      def valid_pages?
        all_leaf?("#{project_path}pages/")
      end

      def valid_drafts?
        all_leaf?("#{project_path}drafts/")
      end

      def all_leaf?(path)
        !Dir.exist?(path) || Dir.children(path).all?(&leaf_ext?)
      end

      def leaf_ext?
        -> (path) { File.extname(path) == ".leaf" }
      end
    end
  end
end

