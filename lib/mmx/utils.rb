module Mmx
  module Utils
    extend self

    def read_yaml(path)
      return {} unless File.exist?(path)

      path.then(&File.method(:read)).then(&YAML.method(:load))
    end

    def erb_template(template, binding)
      template_path = "#{__dir__}/../templates/#{template}.html.erb"
      string = File.open(template_path, "rb", encoding: 'utf-8', &:read)
      ERB.new(string).result(binding)
    end
  end
end

