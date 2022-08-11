class UserMailer < ApplicationMailer
    default from: 'notifications@stockuser.com'

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: 'Welcome to [AppName]')
    end
end
