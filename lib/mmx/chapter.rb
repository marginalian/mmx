module Mmx
  class Chapter
    attr_reader :wiki, :path

    def initialize(wiki, path)
      @wiki = wiki
      @path = path
    end

    def name
      path.split("/").last
    end

    def leaves
      [
        index,
        pages,
        pages_index,
        drafts,
        drafts_index,
        words,
      ].compact.flatten.push(notecards)
    end

    def notecards
      @notecards ||= begin
        return Notecards.new([], self) unless File.exist?(notecards_path)

        array = Notecard.parse(File.read(notecards_path))
        Notecards.new(array, self)
      end
    end

    def index
      Leaf.new(self, "#{path}index.leaf")
    end

    def words
      if File.exist?("#{path}words.leaf")
        Leaf.new(self, "#{path}words.leaf")
      end
    end

    def pages
      return unless pages?

      @page_leaves ||= collected_leaves("pages", :pages)
    end

    def pages_index
      return if pages.nil? || pages.empty?

      Leaf::IndexPage.new(pages)
    end

    def drafts
      return unless drafts?

      @draft_leaves ||= collected_leaves("drafts", :drafts)
    end

    def drafts_index
      return if drafts.nil? || drafts.empty?

      Leaf::IndexPage.new(drafts)
    end

    private

    def pages?
      File.exist?("#{path}pages/")
    end

    def drafts?
      File.exist?("#{path}drafts/")
    end

    def collected_leaves(dir, type)
      Dir.children("#{path}#{dir}/")
        .map { |base| Leaf.new(self, "#{path}#{dir}/#{base}", type) }
        .sort_by(&:base_file_name)
        .reverse
    end

    def notecards_path
      "#{path}notecards.nab".freeze
    end
  end
end

