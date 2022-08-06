class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only, :except => :show

    def after_sign_in_path(resources)
      if current_user.admin?
        redirect admin_path
      else
        redirect root_path
      end
    end

    private

    # def admin_only
    #   unless current_user.admin?
    #     redirect_to root_path, :alert => "Access denied."
    #   end
    # end

  
    def secure_params
      params.require(:user).permit(:role)
    end
  
  end