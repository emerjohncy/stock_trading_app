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
          flash[:alert] = "Insuffient Balance"
        end
      end
    end
  end

  def portfolio
    @user_stocks = Hash.new
    @stocks_owned = []

    @buy_transactions = @user.transactions.where(action: "Buy")
    @sell_transactions = 
    @stocks_transacted_buy = @user.transactions.where(action: "Buy").map{ |transaction| transaction.stock }.uniq
    # @stocks_owned = @stocks_transacted_buy.uniq

    # Number of Units per Stock
    for i in 0...@stocks_transacted_buy.length do
      @user_stocks[@stocks_transacted_buy[i].name] = 0
      @stock_transactions = @user.transactions.where(action: "Buy", stock_id: @stocks_transacted_buy[i].id)
      @stock_transactions.each do |transaction|
        @user_stocks[@stocks_transacted_buy[i].name] += transaction.units
      end
    end

    @user_stocks.each do |stock, units|
      if units != 0
        @stocks_owned.push(stock)
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
