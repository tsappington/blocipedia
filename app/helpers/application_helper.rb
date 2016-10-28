module ApplicationHelper

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new()
    Redcarpet::Markdown.new(renderer, extensions = {}).render(text).html_safe
  end

end
