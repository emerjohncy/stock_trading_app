class Users::DashboardController < ApplicationController
  def index
    @user = User.all 
    @user.each do |user|
      if user.status == "pending"
        flash[:notice] = "Waiting for approval"
        redirect_to root_path and return
      else
        redirect_to users_authenticated_root 
      end
    end
  end
end
