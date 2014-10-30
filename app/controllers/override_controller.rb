class OverrideController < ApplicationController  
  
  def show
    if params[:path] =~ /^[a-z0-9\/-]+$/i # paranoid about weird paths.
      override_file_path = "override/#{params[:path]}.html.erb"
      if File.exists?("app/views/#{override_file_path}")
        render file: override_file_path
        return
      end
    end
    render_404
  end
  
  def show_rock_and_roll
    render file: 'override/catalog/roll-rock-and-roll.html.erb'
  end

end 
