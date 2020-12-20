module ApplicationHelper
  def embedded_svg(filename, options={})
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    svg['class'] = options[:class] if options[:class].present?
    doc.to_html.html_safe
  end

  def unchecked_notifications
    @unchecked_notifications = current_user.passive_notifications.where(checked: false)
  end
end
