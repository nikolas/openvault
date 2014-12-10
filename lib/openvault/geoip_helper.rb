require 'maxminddb'

module Openvault
  module GeoipHelper

    @@db = MaxMindDB.new(Rails.root.join('config', 'geoip', 'GeoLite2-Country.mmdb'))

    def self.get_country_code_for_ip(ip)
      @@db.lookup(ip).country.iso_code
    end
    
  end
end