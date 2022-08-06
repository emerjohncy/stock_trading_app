class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only, :except => :show

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