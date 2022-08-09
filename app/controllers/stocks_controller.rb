class StocksController < ApplicationController
    before_action :authenticate_user!

    def index
        @stocks = Stock.all
    end

    def show
        @stock = Stock.find(params[:id])
    end
    
    def update
        @stock = Stock.find(params[:id])
    
        client = IEX::Api::Client.new
        @updated_price = client.quote(@stock.code).latest_price
        
        if @stock.price != @updated_price
            @stock.update(:price => @updated_price)
            redirect_to stock_path(@stock.id)
        else
            render :show
        end
    end
end
