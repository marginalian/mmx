require_relative "./nabs"

module Mmx
  class Nab
    attr_reader :id, :title, :quote, :source, :author, :note, :refs
    attr_accessor :nab_collection

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
        .then(&method(:nabs))
    end

    def self.hashify(raw_nab)
      raw_nab.split("\n").reduce({}) do |nab, line|
        prefix = line.slice(0)
        txt = line.slice(3..-1)
        key = KEY_MAPPING[prefix.to_sym]

        next nab unless key

        nab[key] = nab[key] ? nab[key] + "\n\n"  + txt : txt
        nab
      end
    end

    def self.nabs(nab_hashes)
      Nabs.new(nab_hashes).tap do |nabs|
        nab_hashes.each { |nab| nab.nab_collection = nabs }
      end
    end

    def mapped_refs
      refs.reduce({}) do |acc, ref|
        ref_nab = self.nab_collection.lookup(ref)
        acc[ref] = ref_nab.title
        acc
      end
    end

    def get_binding
      binding
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
