module Mmx
  module Composable
    def to_proc
      proc(&method(:call))
    end

    def call(...)
      new(...).call
    end
  end
end
