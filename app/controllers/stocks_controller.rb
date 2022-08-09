class StocksController < ApplicationController
    before_action :authenticate_user!

    def index
        @stocks = Stock.all
    end
end
