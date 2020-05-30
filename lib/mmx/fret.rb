module Mmx
  class Fret
    extend Composable

    def initialize(path)
      @notecard_files = Dir.glob(File.join(path, "**", "*.nab"))
    end

    def call
      @notecard_files.map(&Fret::Nab)
    end
  end

  class Fret::Nab
    extend Composable

    def initialize(path)
      @path = path
    end

    def call
      report_validation

      self
    end

    def valid?
      errors.empty?
    end

    def errors
      @errors ||= line_errors + full_text_errors
    end

    private

    attr_reader :path

    def lines
      @lines ||= File.readlines(path)
    end

    def line_errors
      lines.each_with_index.reduce([]) do |acc, (line, i)|
        check_line(acc, line, i)
      end
    end

    def full_text_errors
      return [] unless self.respond_to?(:check_full_text)

      check_full_text(File.read(path))
    end

    def report_validation
      valid? ? report_valid : report_invalid
      puts errors.map { |e| e.prepend("\s\s\s") }
    end

    def report_valid
      puts "✔  #{path}"
    end

    def report_invalid
      puts "✘  #{path}"
    end

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

