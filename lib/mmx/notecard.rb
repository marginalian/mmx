module Mmx
  class Notecard
    attr_reader :id, :title, :quote, :source, :author, :note, :refs
    attr_accessor :notecard_collection

    def initialize(attrs)
      @id = attrs["id"]
      @title = attrs["title"]
      @quote = attrs["quote"]
      @source = attrs["source"]
      @author = attrs["author"]
      @note = attrs["note"]
      @refs = attrs["refs"]&.split("\s") || []
    end

    def self.parse(file_string)
      file_string
        .gsub(/\n\s\s\s/, " ")
        .split("\n\n")
        .map(&method(:hashify))
        .compact
        .map(&method(:new))
    end

    def self.hashify(notecard_file_content)
      notecard_file_content.split("\n").reduce({}) do |notecard, line|
        prefix = line.slice(0)
        txt = line.slice(3..-1)
        key = KEY_MAPPING[prefix.to_sym]

        next notecard unless key

        notecard[key] = notecard[key] ? notecard[key] + "\n\n"  + txt : txt
        notecard
      end
    end

    def mapped_refs
      refs.reduce({}) do |acc, ref|
        ref_notecard = self.notecard_collection.lookup(ref)
        acc[ref] = ref_notecard.title
        acc
      end
    end

    def to_html
      Utils
        .erb_template("partials/notecard", binding)
        .gsub(/-{2}/, "&mdash;")
        .gsub(/__(.*?)__/, '<strong>\1</strong>')
        .gsub(/_(.*?)_/, '<em>\1</em>')
    end

    private

    KEY_MAPPING = {
      '#': 'id',
      '-': 'title',
      '"': 'quote',
      '*': 'source',
      '@': 'author',
      '>': 'note',
      '&': 'refs',
    }
    private_constant :KEY_MAPPING
  end
end

