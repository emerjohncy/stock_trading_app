class Users::DashboardController < ApplicationController
  before_action :get_user

  def index
    @balance = @user.balance
    @stocks = Stock.all.order('created_at ASC')
    @recent_transactions = @user.transactions.last(3).reverse
    # if @user.transactions.exists?
    #   @user.transactions.each do |transaction|
    #     total = transaction.price * transaction.units
    #     if transaction.action == "Buy" && @balance >= total
    #       @balance = @balance - total
    #     elsif transaction.action == "Sell"
    #       @balance = @balance + total
    #     else
    #       flash[:alert] = "Insufficient Balance"
    #     end
    #   end
    # end
  end

  def portfolio
    # Separate all Buy Transactions and Sell Transactions
    @buy_transactions = @user.transactions.where(action: "Buy")
    @sell_transactions = @user.transactions.where(action: "Sell")

    # Get all unique stocks per transaction type
    @stocks_bought = @buy_transactions.map{ |transaction| transaction.stock }.uniq
    @stocks_sold = @sell_transactions.map{ |transaction| transaction.stock }.uniq

    # Store each stock obj to an array and default units to 0
    @user_stocks = @stocks_bought.map{ |stock| {id: stock.id, name: stock.name, units: 0} }
    
    # Add all units from all buy transactions for each stock
    for i in 0...@stocks_bought.length do
      index = @user_stocks.index{ |stock| stock[:id] == @stocks_bought[i].id }
      @stock_transactions = @buy_transactions.where(stock_id: @stocks_bought[i].id)
      @stock_transactions.each do |transaction|
        @user_stocks[i][:units] += transaction.units
      end
    end

    # Deduct all units from all sell transactions for each stock
    for i in 0...@stocks_sold.length do
      index = @user_stocks.index{ |stock| stock[:id] == @stocks_sold[i].id }
      @stock_transactions = @sell_transactions.where(stock_id: @stocks_sold[i].id)
      @stock_transactions.each do |transaction|
        @user_stocks[index][:units] -= transaction.units
      end
    end

    # Get stocks only with units not equal to 0
    @stocks_owned = @user_stocks.select{ |stock| stock[:units] != 0 }

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
