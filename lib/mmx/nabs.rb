require_relative "./composable"
require_relative "./nabs/convert"

module Mmx
  class Nabs < Array
    extend Composable

    def initialize(elements)
      super(elements)
    end

    def call
      self
    end

    def lookup(id)
      find { |nab| nab.id == id }
    end

    def convert(output_format)
      return unless self.length

      Object.const_get("Mmx::Nabs::Convert::#{output_format.capitalize}").(self)
    end
  end
end
