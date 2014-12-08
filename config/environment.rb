# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Openvault::Application.initialize!

class OpenvaultOaiModel
  def earliest
    # TODO, obviously
    '2001-01-01'
  end
end

class OpenvaultOaiProvider < OAI::Provider::Base
  #repository_name 'Openvault' # Used as a name space for source_model
  repository_url 'http://openvault.wgbh.org/oai'
  record_prefix 'oai:TODO'
  admin_email 'openvault@wgbh.org'
  source_model OpenvaultOaiModel.new
end

