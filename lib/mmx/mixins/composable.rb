module Mmx
  module Composable
    def to_proc
      proc(&method(:call))
    end

    def call(*args)
      new(*args).call
    end
  end
end

