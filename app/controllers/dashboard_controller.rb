class DashboardController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  def admin_dashboard
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def trader_dashboard
    unless current_user.trader?
      redirect_to root_path, :alert => "Access denied."
    end
  end

end