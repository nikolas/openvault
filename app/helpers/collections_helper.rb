module CollectionsHelper

  def collab_status(collection, user)   
    status = collection.status(user)
    "(#{status})" if status
  end
  
end
