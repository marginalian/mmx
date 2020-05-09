require "ostruct"

require_relative "../../composable"
require_relative "../../emender"

module Mmx
  class Topo
    class Convert
      class Leaf
        extend Composable

        def initialize(syntax_tree, _nabs)
          @syntax_tree = syntax_tree
          @prev_entry = nil
        end

        def call
          syntax_tree.each_with_index.reduce("", &method(:translate)).concat("\n")
        end

        private

        attr_reader :syntax_tree
        attr_accessor :prev_entry

        def translate(leaf_string, pair)
          tree_entry, index = pair
          prev_pre = syntax_tree[index - 1]&.fetch(:prefix)
          next_pre = syntax_tree[index + 1]&.fetch(:prefix)
          this_pre = tree_entry[:prefix]
          arr = tree_entry[:arr]
          guide = mapping[this_pre.to_sym]

          if !guide[:replace].nil?
            return "#{leaf_string}\n#{guide[:replace]}"
          elsif guide[:below]
            next_leaf = "#{arr.first}\n#{guide[:below]}"
            next_leaf.concat("\n") if next_pre != "~"
          elsif guide[:pre].nil?
            next_leaf = arr.join("\n\n")
          else
            next_leaf = arr.map { "#{guide[:pre]} #{_1}".strip }.join("\n")
            return "#{leaf_string}\n#{next_leaf}" unless prev_pre == "~"
          end

          "#{leaf_string}#{next_leaf}"
        end

        def mapping
          {
            '~': { replace: "\n" },
            '.': {},
            '-': { below: "-" },
            '=': { below: "--" },
            '|': { pre: '|' },
            '+': { pre: '-' },
            '_': { replace: '___' },
            '/': { pre: '/' },
            '#': { pre: '||' },
          }
        end
      end
    end
  end
end
