module Admin::BugsHelper

  def bug_priority(bug)
    case bug.priority
      when 0; 'Low'
      when 1; 'Medium'
      when 2; 'High'
    end
  end

  def display_bug_text(bug, type)
    text = bug.send type.to_sym
    filter = bug.send :"#{type}_filter"
    options = {}
    if filter == 'bluecloth'
      options[:class] = 'buginfo'
      options[:transform] = Proc.new { |str| BlueCloth.new(str).to_html }
    else
      options[:tag] = :pre
    end
    more_less_text(text, options)
  end
  
end
