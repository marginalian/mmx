module Mmx
  class Leaf
    class SyntaxTree
      class List
        extend Composable

        # @param concat [Boolean] used to connect indented lines with the previous list item
        def initialize(tree, prev, line, type, lvl = nil, concat = false)
          @tree = tree
          @prev = prev
          @line = line
          @type = type
          @lvl = lvl || line.index(type == :ulist ? "-" : "#")
          @concat = concat
        end

        def call
          begin
            if concat
              last_list_item.concat(text_without_prefix)
            elsif first_item_in_list?
              tree.push(new_full_entry)
            elsif top_level_list_item?
              prev_arr.push(text_without_prefix)
            elsif item_level_group_exists?
              item_level_group[:arr].push(text_without_prefix)
            else
              new_level_group.push(new_full_entry)
            end
          rescue => e
            puts "LIST ERROR: #{e}"
            puts "Please check your list indentation for line: #{line}"
          end
        end

        private

        attr_reader :tree, :prev, :line, :type, :lvl, :concat

        def last_list_item
          top_level_list_item? ? prev_arr.last : item_level_group[:arr].last
        end

        def first_item_in_list?
          prev_type != type
        end

        def top_level_list_item?
          lvl.zero?
        end

        def second_level?
          new_level_group_path.empty?
        end

        def new_level_group_path
          Array.new(((lvl / 2) - 1), [:arr, -1]).flatten.drop(1)
        end

        def new_level_group
          second_level? ? prev_arr : prev_arr.dig(*new_level_group_path)[:arr]
        end

        def item_level_group_exists?
          item_level_group.class == Hash
        end

        def item_level_group
          @item_level_group ||= begin
            digs = Array.new((lvl / 2), [:arr, -1]).flatten.drop(1)
            prev_arr.dig(*digs)
          end
        end

        def prev_type 
          prev&.dig(:type)
        end

        def prev_arr 
          prev&.dig(:arr)
        end

        def prev_lvl 
          prev&.dig(:lvl)
        end

        def text_without_prefix 
          line.gsub(/^\s*[-#]\s/, "")
        end

        def new_full_entry
          {
            type: type,
            arr: [text_without_prefix],
            lvl: lvl,
          }
        end
      end
    end
  end
end
