class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create # rubocop:todo Lint/UselessMethodDefinition
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
