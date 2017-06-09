class RegistrationsController < Devise::RegistrationsController

  # Overwrite update_resource to let users to update their user without giving their password
  protected
     def update_resource(resource, params)
         resource.update_without_password(params)
     end

end
