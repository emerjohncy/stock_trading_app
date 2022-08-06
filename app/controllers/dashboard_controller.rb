class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => :home


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