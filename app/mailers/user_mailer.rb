class UserMailer < ApplicationMailer
    default from: 'notifications@stockname.com'

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: 'Welcome to [AppName]')
    end
end
