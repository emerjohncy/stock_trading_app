class Users::DashboardController < ApplicationController
  before_action :get_user

  def index
    @balance = @user.balance
    @stocks = Stock.all
    @recent_transactions = @user.transactions.last(3).reverse
  end

  private

  def get_user
    @user = User.find(current_user.id)
  end
end
