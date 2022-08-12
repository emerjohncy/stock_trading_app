class Users::DashboardController < ApplicationController
  before_action :get_user

  def index
    @balance = @user.balance
    @stocks = Stock.all.order('created_at ASC')
    @recent_transactions = @user.transactions.last(3).reverse
    if @user.transactions.exists?
      @user.transactions.each do |transaction|
        total = transaction.price * transaction.units
        if transaction.action == "Buy" && @balance >= total
          @balance = @balance - total
        elsif transaction.action == "Sell"
          @balance = @balance + total
        else
          flash[:alert] = "Insufficient Balance"
        end
      end
    end
  end

  private

  def get_user
    @user = User.find(current_user.id)
    if @user.status == "pending"
      flash[:notice] = "Waiting for approval"
      redirect_to root_path 
    elsif @user.status == "deactivate"
      flash[:notice] = "deactivate account"
      redirect_to root_path 
    end
  end
end
