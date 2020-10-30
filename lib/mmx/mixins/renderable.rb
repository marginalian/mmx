module Renderable
  def config
    chapter.wiki.config
  end

  def show_lower_nav?
    true
  end

  def custom_nav_links
    config["nav_links"]
  end

  def path_to_root
    case self.class.name.split('::').last
    when "AllPagesIndex" then "./"
    when "IndexPage" then "../../"
    when "Notecards" then "../"
    when "Leaf" then self.type == :index ? "../" : "../../"
    else
      raise "No path to root found for class: #{self.class.name.split('::').last}"
    end
  end
end

