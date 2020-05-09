require_relative "./base_validator"
require_relative "../nab"

module Mmx
  class Fret
    class Nab < BaseValidator

      def check_full_text(text)
        nabs = Mmx::Nab.parse(text)
        errors = []

        nabs.each_with_index do |nab, i|
          if !nab.id
            errors.push("Nab ##{i + 1} does not have an id")
          end

          if nabs.select { |other_nab| nab.id == other_nab.id }.length > 1
            errors.push("ID #{nab.id} is not unique")
          end
        end

        errors
      end

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
        return acc if /\s{3}\S/ === line

        unless /^[\-\#\@\"\>\*\&\\]\s{2}\S/ === line
          acc.push("line #{line_no} contains a malformed prefix")
        end

        acc
      end
    end
  end
end
