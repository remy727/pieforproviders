# frozen_string_literal: true

# Create Registrations for Users
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :active,
      :email,
      :full_name,
      :get_from_pie,
      :greeting_name,
      :language,
      :not_as_much_money,
      :opt_in_email,
      :opt_in_text,
      :organization,
      :password,
      :password_confirmation,
      :phone_number,
      :phone_type,
      :service_agreement_accepted,
      :state,
      :timezone,
      :too_much_time,
      :heard_about
    )
  end
end
