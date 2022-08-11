class Users::DashboardController < ApplicationController
  before_action :get_user

  def index
    @balance = @user.balance
    @stocks = Stock.all.order('created_at ASC')
    @recent_transactions = @user.transactions.last(3).reverse
  end

  private

  def get_user
    @user = User.find(current_user.id)
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
