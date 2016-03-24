class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  skip_before_filter :verify_authenticity_token, :only => [:destroy, :create]


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
    sign_in(resource_name, resource)
    respond_to do |format|
      format.js
    end
  end

  # DELETE /resource/sign_out
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    respond_to do |format|
      format.js
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
