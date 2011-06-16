module FoldersHelper

  def folder_path(folder, sep = ' &raquo; ')
    folder.path.collect { |f| link_to(f.title, polymorphic_path([@folderable, f])) }.join(sep)
  end

  def folder_tree_items(folder, tier = 1)
    spacer = " " * (tier * 5)
    js  = "#{spacer}['#{escape_javascript(folder.title)} (#{folder.num_docs.to_s})', '#{link_to_folder_contents(folder)}'"
    if folder.children.length > 0
      js += ",\n" + folder.children.collect { |c| folder_tree_items(c, tier + 1) }.join(",\n")
    end
    js += "\n#{spacer}]"
    js
  end

  def link_to_folder_contents(folder)
    escape_javascript "javascript: show_folder_contents('#{polymorphic_path([:folder_contents, @folderable, folder])}', '#{form_authenticity_token}')"
  end

  def folderable_links
    if block_given?
      l = yield([])
    else
      l = []
    end
    case @folderable
    when Pickup
      l << link_to("Pickups List", pickups_path)
    when Client
      if solution_owner_user?
        l << link_to("Clients List", clients_path)
      end
    end
    content_tag(:p, l.join(" | "))
  end
  
end
