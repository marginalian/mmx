module Mmx
  class Leaf
    class SyntaxTree
      extend Composable

      def initialize(lines)
        @lines = lines
        @checkbox_id_num = 0
      end

      def call
        @lines.reduce([], &method(:parse_line))
      end

      private

      def parse_line(tree, line)
        line = line.gsub(/\n\w/, "\s")
        type = determine_type(line)
        prev = tree[-1] if tree.length > 0

        if self.respond_to?(type, :include_private)
          __send__(type, tree, prev, line)
        else
          remove_prefix_then_create(type, tree, prev, line)
        end

        tree
      end

      def determine_type(line)
        case line
        when /^\~+$/
          :break
        when /^={3}$/
          :double_line
        when /^_{3}/
          :line
        when /^\/\s/
          :comment
        when /^-+$/
          :heading
        when /^-\s./
          :list
        when /^\s*\[.\]/
          :checkbox
        when /^\s{2}\w/
          :potential_list_item
        when /^\|{2}\s/
          :code
        when /^\|\s\S/
          :blockquote
        else
          :paragraph
        end
      end

      def heading(_tree, prev, line)
        prev[:type] = :heading
        prev[:lvl] = line.strip.length
      end

      def checkbox(tree, prev, line)
        tree.push({ type: /\[x\]/.match?(line) ? :todo_checked : :todo_unchecked })
        tree.push({ type: :todo_label, arr: [line.gsub(/^\s*\[.\]/, '').strip] })
      end

      def potential_list_item(tree, prev, line)
        return unless prev&.fetch(:type) == :list

        text = line.gsub(/^\s/, "")
        prev[:arr].last.concat(text)
      end

      def paragraph(tree, prev, line)
        if line == ""
          tree.push({ type: :space, arr: [] })
          return
        end

        text = line.strip

        if prev&.fetch(:type) == :paragraph
          prev[:arr].last.concat("\n#{text}")
        else
          tree.push({ type: :paragraph, arr: [text] })
        end
      end

      def blockquote(tree, prev, line)
        text_without_prefix = line.gsub(/^\S+\s/, "").strip

        if text_without_prefix == ""
          tree.push({ type: :space, arr: [] })
          return
        end

        if prev&.fetch(:type) == :blockquote
          prev[:arr].push(text_without_prefix)
        else
          tree.push({ type: :blockquote, arr: [text_without_prefix] })
        end
      end

      def remove_prefix_then_create(type, tree, prev, line)
        text_without_prefix = line.gsub(/^\S+\s/, "")
        combine_or_create(tree, prev, text_without_prefix, type)
      end

      def combine_or_create(tree, prev, text, type)
        if prev&.fetch(:type) == type
          prev[:arr].push(text)
        else
          tree.push({ type: type, arr: [text] })
        end
      end
    end
  end
end

