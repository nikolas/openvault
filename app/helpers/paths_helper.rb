module PathsHelper
  def series_path(object)
    catalog_path(object)
  end
  def program_path(object)
    catalog_path(object)
  end
  private
  def catalog_path(object)
    "/catalog/#{slug_or_pid object}"
  end
  def slug_or_pid(object)
    case object
    when String
      object
    else
      object.datastreams['slug'].content rescue object.pid
    end
  end
end
