module Mmx
  class Renderer
    class UberBinding
      def initialize(renderer, partial_context = nil)
        @partial_context = OpenStruct.new(partial_context)
        @renderer = renderer
      end

      def public_binding
        binding
      end

      def method_missing(m, *args, &block)
        if renderer.respond_to?(m)
          renderer.send(m, *args, &block)
        elsif Helpers.respond_to?(m)
          Helpers.send(m, *args, &block)
        elsif partial_context.respond_to?(m)
          partial_context.send(m, *args, &block)
        else
          raise "Renderer could not find method: #{m}"
        end
      end

      private

      attr_reader :partial_context, :renderer
    end
  end
end

