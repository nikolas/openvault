require 'rsolr'
require 'openvault/slug_setter'

namespace :openvault do
  desc "Set slugs on all unslugged records"
  task :set_missing_slugs => :environment do |t, args|
    Openvault::SlugSetter.set_missing_slugs
  end
  
  desc "Reset the slug on a single record"
  task :reset_slug => :environment do |t, args|
    OLD_ID_PARAM = 'old_id'
    OTHER_ID_PARAM = 'other_id'
    SLUG_PARAM = 'new_slug'
    
    if (!ENV[OLD_ID_PARAM] && !ENV[OTHER_ID_PARAM]) || !ENV[SLUG_PARAM]
      raise ArgumentError, "USAGE: rake openvault:reset_slug #{OLD_ID_PARAM}=[id]|#{OTHER_ID_PARAM}=[other_id] #{SLUG_PARAM}=[slug]"
    elsif ENV[OLD_ID_PARAM] && ENV[OTHER_ID_PARAM]
      raise ArgumentError, "Specify either #{OLD_ID_PARAM} or #{OTHER_ID_PARAM}, not both."
    end
    
    Openvault::SlugSetter.reset_slug old_id: ENV[OLD_ID_PARAM], other_id: ENV[OTHER_ID_PARAM], slug: ENV[SLUG_PARAM]    
  end
  
  desc "Reset slugs on multiple records"
  task :reset_slugs => :environment do |t, args|
    FILE_PARAM = 'file'
    if !ENV[FILE_PARAM]
      raise ArgumentError, "USAGE: rake openvault:reset_slugs #{FILE_PARAM}=[filename]"
    end
    File.open(ENV[FILE_PARAM], "r") do |f|
      f.each_line do |line|
        line.chomp!
        slug, other_id = line.split "\t" # This is arbitrary, but matches the order of the file we have.
        Openvault::SlugSetter.reset_slug other_id: other_id, slug: slug
      end
    end
  end

end
