class StocksController < ApplicationController
    before_action :authenticate_user!
    before_action :get_user

    def show
        @stock = Stock.find(params[:id])
        client = IEX::Api::Client.new
        @updated_price = client.quote(@stock.code).latest_price
        @stock.update(price: @updated_price)
        @stock.save
    end

    private

    def get_user
        @user = User.find(current_user.id)
    end
end
