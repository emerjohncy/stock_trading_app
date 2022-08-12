class UserMailer < ApplicationMailer
    default from: 'notifications@stockname.com'

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: 'Welcome to [AppName]')
    end

    def status_approve
        @user = params[:user]
        mail(to: @user.email, subject: 'AppName Account Approval')
    end
end
