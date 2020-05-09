require "ostruct"

require_relative "../composable"

module Mmx
  class Fret
    class BaseValidator
      extend Composable

      def initialize(path, report: true)
        @path = path
        @report = report
      end

      def call
        report_validation if report

        ::OpenStruct.new({
          path: path,
          valid: valid?,
          errors: errors,
        })
      end

      private

      attr_reader :path, :report

      def lines
        @lines ||= File.readlines(path)
      end

      def errors
        @errors ||= line_errors + full_text_errors
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

      def valid?
        errors.empty?
      end

      def report_valid
        puts "✔  #{path}"
      end

      def report_invalid
        puts "✘  #{path}"
      end
    end
  end
end
