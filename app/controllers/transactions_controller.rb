class TransactionsController < ApplicationController
    before_action :authenticate_admin!, only: [:all_transactions]
    before_action :authenticate_user!, only: [:buy, :create, :stock_transactions, :user_transactions]
    before_action :get_user, only: [:buy, :create, :stock_transactions, :user_transactions]
    before_action :get_stock, only: [:buy, :create, :stock_transactions]

    def all_transactions
        @transactions = Transaction.all
    end

    def user_transactions
        @transactions = @user.transactions.order('created_at DESC')
    end

    def stock_transactions
        @transactions = @user.transactions.where(stock_id = @stock.id)
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
            redirect_to users_authenticated_root_path   #change redirect path to portfolio path once available
        else
            render :buy, status: :unprocessable_entity
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
        params.require(:transaction).permit(:stock_id, :action, :status, :price, :units)
    end
end
