require_relative 'oai_model'

# TODO: Rails autoloading doesn't work, and changes here do not take effect
# without restarting the server. Argh.

class OaiProvider < OAI::Provider::Base
  #repository_name 'Openvault' # Used as a name space for source_model
  repository_url 'http://openvault.wgbh.org/oai'
  record_prefix 'oai:TODO'
  admin_email 'openvault@wgbh.org'
  source_model OaiModel.new
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
    def f.encode(model, object)
      # TODO: look at model
      object.xml
    end
  }
  register_format format
end