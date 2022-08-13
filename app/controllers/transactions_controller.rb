class TransactionsController < ApplicationController
    before_action :authenticate_admin!, only: [:all_transactions]
    before_action :authenticate_user!, only: [:user_transactions, :buy, :sell, :create_buy, :create_sell, :buy_transactions, :sell_transactions]
    before_action :get_user, only: [:user_transactions, :buy_transactions, :buy, :create_buy, :sell_transactions, :create_sell, :sell]
    before_action :get_stock, only: [:buy_transactions, :buy, :create_buy, :sell_transactions, :create_sell, :sell]

    def all_transactions
        @transactions = Transaction.all
    end

    def user_transactions
        @transactions = @user.transactions.order('created_at DESC')
    end

    def buy_transactions
        @transactions = @user.transactions.where(stock_id: @stock.id, action: "Buy")
    end

    def buy
        @transaction = @user.transactions.build
    end
    
    def create_buy
        @transaction = @user.transactions.build(transaction_params)
        @transaction.stock_id = @stock.id
        @transaction.action = "Buy"
        @transaction.status = "Open"
        @transaction.price = @stock.price
        
        @total_price = @transaction.units * @stock.price

        if @total_price <= @user.balance
            @transaction.save
            @user.balance -= @total_price
            @user.save
            flash[:notice] = "Bought #{@transaction.units} units of #{@stock.code}"
            redirect_to users_portfolio_path
        else
            flash[:alert] = "Insufficient Balance"
            render :buy, status: :unprocessable_entity
        end
    end
        
    def sell_transactions
        @transactions = @user.transactions.where(stock_id: @stock.id, action: "Sell")
    end

    def sell
        @transaction = @user.transactions.build
    end

    def create_sell
        @transaction = @user.transactions.build(transaction_params)
        @transaction.stock_id = @stock.id
        @transaction.action = "Sell"
        @transaction.status = "Close"
        @transaction.price = @stock.price

        # Get max stocks that can be bought
        @max_stocks = 0
        @buy_transactions = @user.transactions.where(action: "Buy")
        @buy_stock_transactions = @buy_transactions.where(stock_id: @stock.id)
        @buy_stock_transactions.each do |transaction|
            @max_stocks += transaction.units
        end

        if @transaction.units <= @max_stocks
            @transaction.save
            @profit = @transaction.price * @transaction.units
            @user.balance += @profit
            @user.save
            flash[:notice] = "Sold #{@transaction.units} units of #{@stock.code}"
            redirect_to users_portfolio_path
        elsif @transaction.units > @max_stocks
            flash[:alert] = "Insufficient Number of Units"
            render :sell, status: :unprocessable_entity
        end
    end
    
    private
    
    def get_user
        @user = User.find(current_user.id)
    end
    
    def get_stock
        @stock = Stock.find(params[:id])
    end

    def transaction_params
        params.require(:transaction).permit(:units)
    end
end
