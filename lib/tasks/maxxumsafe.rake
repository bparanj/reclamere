namespace :maxxumsafe do

  desc "Show links to documents whose files do not exist on disk."
  task :show_missing_files => :environment do
    docs = Document.all.map do |d|
      if !d.file_exist?
        case d.folder.folderable
        when Client
          "http://www.maxxumsafe.com/clients/#{d.folder.folderable_id}/folders/#{d.folder_id}/documents/#{d.id}"
        when Pickup
          "http://www.maxxumsafe.com/pickups/#{d.folder.folderable_id}/folders/#{d.folder_id}/documents/#{d.id}"
        else
          nil
        end
      else
        nil
      end
    end
    puts docs.compact.join("\n")
  end

  desc "Show files whose documents do not exist in the database."
  task :show_missing_documents => :environment do
    files = Dir.glob(AppUtils.storage('document') + "/**/*")
    missing = files.map do |f|
      sha1 = f.split('/')[-2,2].join
      conditions = { :sha1 => sha1 }
      if !Document.exists?(conditions) && !Document::Version.exists?(conditions)
        if af = Document.absolute_filename(sha1)
          af
        else
          nil
        end
      else
        nil
      end
    end
    puts missing.compact.join("\n")
  end

end
