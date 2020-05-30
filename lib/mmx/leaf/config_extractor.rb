module Mmx
  class Leaf
    class ConfigExtractor
      extend Composable

      ##
      # see:
      # https://github.com/jekyll/jekyll/blob/master/lib/jekyll/document.rb#L13
      CONFIG_REGEX = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

      def initialize(file_content)
        @file_content = file_content
      end

      def call
        config_match = file_content[CONFIG_REGEX, 1]

        if !config_match.nil?
          config = YAML.load(config_match)
          content = $'

          [config, content]
        else
          [{}, file_content]
        end
      end

      private

      attr_reader :file_content
    end
  end
end

