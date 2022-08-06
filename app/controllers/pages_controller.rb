class PagesController < ApplicationController
    before_action :authenticate_user!, :except => :home

    def home
        
    end

    def admin_dashboard
    
    end

    def trader_dashboard
    
    end
end