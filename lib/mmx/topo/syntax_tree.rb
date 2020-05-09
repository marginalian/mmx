require_relative "../composable"

module Mmx
  class Topo
    class SyntaxTree
      extend Composable

      def initialize(file_content_lines)
        @file_content_lines = file_content_lines
      end

      def call
        @file_content_lines.reduce([], &method(:parse_line))
      end

      private

      def parse_line(tree, line)
        if line.empty?
          tree.push({ prefix: "~", arr: [] })
          return tree
        end

        prev = tree[-1] if tree.length > 0
        prefix = line.slice(0)
        txt = line.slice(3..-1)

        if line.match? /^\s{3}\S.+/
          if prev[:prefix] == "."
            prev[:arr].last.concat("\n#{txt}")
          else
            prev[:arr].push(txt)
          end

          return tree
        end

        if prev&.fetch(:prefix) == prefix
          prev[:arr].push(txt)
        else
          tree.push({ prefix: prefix, arr: [txt] })
        end

        tree
      end
    end
  end
end
