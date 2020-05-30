module Mmx
  class Notecards < Array
    include Renderable

    attr_reader :chapter

    def initialize(elements, chapter)
      @chapter = chapter

      init_collection(elements)
      super(elements)
    end

    def init_collection(elements)
      elements.each do |notecard|
        notecard.notecard_collection = self
      end
    end

    def lookup(id)
      find { |card| card.id == id.to_s }
    end

    def notecard_count
      length
    end

    def first_at
      return unless map(&:id).min

      DateTime.strptime(map(&:id).min,'%s').to_date.to_s
    end

    def last_at
      return unless map(&:id).min

      DateTime.strptime(map(&:id).max,'%s').to_date.to_s
    end

    def site_file_name
      "#{chapter.name}/notecards"
    end

    def to_html
      self.reduce("") { |acc, notecard| acc + notecard.to_html }
    end

    def type
      :notecards
    end
  end
end

