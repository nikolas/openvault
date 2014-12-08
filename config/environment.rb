# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Openvault::Application.initialize!

class OpenvaultOaiModel
  def earliest
    # Used by 'Identify'
    # TODO
    '2001-01-01'
  end
  def latest
    # Used by 'ListMetadataFormats'
    # TODO
    Time.now
  end
  def sets
    # TODO: perhaps different sets for different asset types?
    []
  end
end

class OpenvaultOaiProvider < OAI::Provider::Base
  #repository_name 'Openvault' # Used as a name space for source_model
  repository_url 'http://openvault.wgbh.org/oai'
  record_prefix 'oai:TODO'
  admin_email 'openvault@wgbh.org'
  source_model OpenvaultOaiModel.new
  format = Object.new.tap {|f|
    def f.prefix
      'pbcore'
    end
    def f.schema
      'http://pbcore.org/xsd/pbcore-2.0.xsd'
    end
    def f.namespace
      'http://www.pbcore.org/PBCore/PBCoreNamespace.html'
    end
  }
  register_format format
end

