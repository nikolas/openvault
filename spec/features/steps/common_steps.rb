module CommonSteps
  
  # visit if not there already
  def go_here (path)
    visit path unless current_path == path
  end
end