class RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      #"/scholar/#{resource.username}"
    end
end