class OverrideController < ApplicationController  
  
  def show
    render_404 unless params[:path] =~ /^[a-z0-9\/-]+$/i # paranoid about weird paths.
    override_file_path = "override/#{params[:path]}.html.erb"
    if File.exists?("app/views/#{override_file_path}")
      render file: override_file_path
    else
      render_404
    end
  end
  
  private
  
  def render_404
    render 'catalog/no_record_found', status: :not_found, formats: :html
  end

end 
