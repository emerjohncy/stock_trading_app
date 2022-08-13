class TransactionsController < ApplicationController
    before_action :authenticate_admin!, only: [:all_transactions]
    before_action :authenticate_user!, only: [:buy, :sell, :create, :create_sell, :stock_transactions, :sell_transactions, :user_transactions]
    before_action :get_user, only: [:buy, :sell, :create, :create_sell, :stock_transactions, :sell_transactions, :user_transactions]
    before_action :get_stock, only: [:buy, :sell, :create, :create_sell, :stock_transactions, :sell_transactions]

    def all_transactions
        @transactions = Transaction.all
    end

    def user_transactions
        @transactions = @user.transactions.order('created_at DESC')
    end

    def stock_transactions
        @transactions = @user.transactions.where(stock_id: @stock.id, action: "Buy")
    end

    def buy
        @transaction = @user.transactions.build
        # @transaction.stock_id = @stock.id
        # @transaction.action = "Buy"
        # @transaction.status = "Open"
        # @transaction.price = @stock.price
    end
    
    def create
        # transaction_params = {
            #     stock_id: @stock.id,
            #     action: "Buy",
            #     status: "Open",
            #     price: @stock.price
            # }
            
            @transaction = @user.transactions.build(transaction_params)
            @transaction.stock_id = @stock.id
            @transaction.action = "Buy"
            @transaction.status = "Open"
            @transaction.price = @stock.price
            
            if @transaction.save
                flash[:notice] = "Bought a Stocks"
                redirect_to users_portfolio_path
            else
                flash[:alert] = "insufficient Balance"
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
     
            if @transaction.save
                @profit = @transaction.price * @transaction.units
                @user.balance += @profit
                flash[:notice] = "Sold #{@transaction.units} units of #{@stock.code}"
                redirect_to users_portfolio_path
            else
                flash[:alert] = "insufficient Number of Units"
                render :sel, status: :unprocessable_entity
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
