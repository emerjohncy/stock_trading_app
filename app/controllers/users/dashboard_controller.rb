class Users::DashboardController < ApplicationController
  before_action :get_user

  def index
    @balance = @user.balance
    @stocks = Stock.all
  end

  private

  def get_user
    @user = User.find(current_user.id)
  end
end
