module Mmx
  module Site
    extend self

    HOST_LOC = "#{__dir__}/../../.."
    SITE_PATH = "#{HOST_LOC}/site"

    def refresh(wiki)
      FileUtils.remove_dir(SITE_PATH) if File.exists?(SITE_PATH)

      wiki.chapters.map(&:name).each do |name|
        try_mkdir(SITE_PATH)
        try_mkdir("#{SITE_PATH}/#{name}")
        try_mkdir("#{SITE_PATH}/#{name}/pages")
        try_mkdir("#{SITE_PATH}/#{name}/drafts")
      end
    end

    def try_mkdir(path)
      Dir.mkdir(path) unless File.exists?(path)
    end
  end
end

