module ApplicationHelper
  
  # Flash Messages
	def flash_messages
    %w(notice success alert).each do |msg|
    concat content_tag(:div, content_tag(:p, flash[msg.to_sym]),
      :class => "#{msg}") unless flash[msg.to_sym].blank?
    end
  end
  
  def breadcrumbs(opts = {})
    html = ""
    opts.each do |opt|
      html << " &raquo; ".html_safe unless opt == opts.first
       html << ( opt[1] == nil ? opt[0] : link_to(opt[0], opt[1]) )
      
    end
    
    return html.html_safe
  end
  
  def currency(amount)
    "$#{sprintf("%.2f", amount)}"
  end
  
end
