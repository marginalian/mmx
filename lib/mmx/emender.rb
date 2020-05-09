require_relative "./composable"
require_relative "./emender/html_library"
require_relative "./emender/markdown_library"

module Mmx
  class Emender
    extend Composable

    def initialize(input, nabs, library_name = :html)
      @input = input
      @nabs = nabs
      @library_name = library_name
      @library = LIBRARIES[library_name]
    end

    def call
      input
        .then(&method(:tokenize))
        .then(&method(:parenthesize))
        .then(&method(:interpret))
    end

    def tokenize(input)
      input.split('"')
        .each_with_index.map { |x, i| whiten(x, i) }
        .join('"')
        .strip
        .split(/\s+/)
        .map{ |x| x.gsub(/!whitespace!/, " ") }
    end

    def parenthesize(tokens, list = [])
      case token = tokens.shift
      when nil
        list.pop
      when "("
        list << parenthesize(tokens, [])
        parenthesize(tokens, list)
      when ")"
         list
      else
        parenthesize(tokens, list.push(categorize(token)))
      end
    end

    def interpret_list(input_list)
      list = input_list.map(&method(:interpret))

      if list.first.respond_to?(:call)
        return list.first.call(*list.slice(1..), nabs: nabs)
      end

      list
    end

    def interpret(input)
      if input.kind_of?(Array)
        interpret_list(input)
      elsif input[:type] == "identifier"
        access_library_method(input[:value])
      elsif input[:type] == "string"
        input[:value]
      else
        raise EmenderError, "cannot interpret node of type #{input[:type]}"
      end
    end

    private

    attr_reader :library, :library_name, :input, :nabs

    LIBRARIES = { html: HTML_LIBRARY, markdown: MARKDOWN_LIBRARY }
    private_constant :LIBRARIES

    def access_library_method(name)
      if library.keys.include?(name.to_sym)
        return library[name.to_sym]
      end

      raise EmenderError, "#{name} not found in #{library_name}"
    end

    def whiten(x, i)
      if i % 2 == 0
        x.gsub(/\(/, ' ( ').gsub(/\)/, ' ) ')
      else
        x.gsub(/\s/, "!whitespace!")
      end
    end

    def categorize(token)
      if token[0] == '"' && token[-1] == '"'
        { type: 'string', value: token.gsub('"', '') }
      else
        { type: 'identifier', value: token }
      end
    end
  end

  class EmenderError < StandardError; end
end
