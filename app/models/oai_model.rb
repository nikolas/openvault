# TODO: Changes do not take effect without restarting Rails.

class OaiModel
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
  def find(id, options)
    if id == :all
      [OaiModel.mock_object]
    else  
      OaiModel.mock_object
    end
  end
  def self.mock_object
    Object.new.tap{|o|
      def o.id
        'id-TODO'
      end
      def o.timestamp_method
        # TODO
        Time.now
      end
    }
  end
  def timestamp_field
    'timestamp_method'
  end
end