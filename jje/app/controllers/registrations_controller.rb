# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def update
    super
  end

  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:signup, keys: [:display_name, :email, :password, :password_confirmation])
  	devise_parameter_sanitizer.permit(:account_update, keys: [:display_name, :email, :password, :password_confirmation])
  end
end