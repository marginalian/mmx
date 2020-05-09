require_relative "./base_validator"

module Mmx
  class Fret
    class Topo < BaseValidator

      private

      def check_line(acc, line, i)
        return acc if line == "_\n"
        return acc if line[0] == "/"

        line_no = i + 1
        prev = i == 0 ? nil : lines[i - 1]

        if line == "\n" && prev == "\n"
          acc.push("line #{line_no} is a double space line")
          return acc
        end

        return acc if line == "\n"

        unless /^[\.\-\#\+\=\s\|]\s{2}\S/ === line
          acc.push("line #{line_no} contains a malformed prefix")
        end

        acc
      end
    end
  end
end
