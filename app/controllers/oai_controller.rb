class OaiController < ApplicationController
  @@provider = OaiProvider.new
  def index
    # Remove controller and action from the options. Rails adds them automatically.
    options = params.delete_if { |k,v| %w{controller action}.include?(k) }
    response = @@provider.process_request(options)
    render :text => response, :content_type => 'text/xml'
  end
end