class OverrideController < ApplicationController  
  
  def show
    raise 'Bad URL' unless params[:path] =~ /^[a-z\/-]+$/ # should have been caught by routes.rb
    override_file_path = "override/#{params[:path]}.html.erb"
    if File.exists?("app/views/#{override_file_path}")
      render file: override_file_path
    else
      render 'catalog/no_record_found', status: :not_found, formats: :html
    end
  end

end 
