module Mmx
  class Renderer
    extend Forwardable

    attr_reader :page

    def initialize(page)
      @page = page
    end

    def render
      File.open(dest_path, "w") { |f| f.puts html }
    end

    def render_partial(path, partial_variables=nil)
      partial = File.read("#{TEMPLATES_PATH}/partials/#{path}.html.erb")
      uber_binding = UberBinding.new(self, partial_variables).public_binding
      ERB.new(partial).result(uber_binding)
    end

    private

    def uber_binding
      UberBinding.new(self).public_binding
    end

    def html
      ERB.new(template).result(uber_binding)
    end

    def dest_path
      "#{SITE_PATH}/#{page.site_file_name}.html"
    end

    def template
      File.read("#{TEMPLATES_PATH}/#{type}.html.erb")
    end

    def type
      page.class.name.split('::').last.downcase
    end
  end
end

