module SharedMethods
  extend ActiveSupport::Concern

  def original_file_name
    filename = ''
    for i in 0..pbcore.instantiations.count do
      instantiation = pbcore.instantiations(i)
      for j in 0..instantiation.id.count do
        instantiation_id = instantiation.id(j)
        if instantiation_id.source == ["Original file name"]
          filename = instantiation_id.first
        end
      end
    end
    filename
  end

end
