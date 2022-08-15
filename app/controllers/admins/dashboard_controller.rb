class Admins::DashboardController < ApplicationController
  before_action :set_user, only: %i[ show edit update change_status ]
  
  def index
    @users = User.all.order('created_at DESC')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Account has been created successfully"
      redirect_to admins_authenticated_root_path
    else
      flash.now[:alert] = "Something went wrong"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit 
  end

  def update
    if @user.update_with_password(user_params)
      flash[:notice] = "Account has been updated successfully"
      redirect_to admins_view_user_path(@user)
    else
      flash.now[:alert] = "Something went wrong"
      render :edit, status: :unprocessable_entity
    end
  end

  def change_status
    if @user.update(status: params[:status])
      flash[:notice] = "Status updated to #{@user.status}"
      redirect_to admins_authenticated_root_path
      if @user.status == "active"
        UserMailer.with(user: @user).status_approve.deliver_now
      end
    else
      flash.now[:alert] = "Something went wrong"
      render @user, status: :unprocessable_entity
    end
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :status, :balance, :password, :password_confirmation, :current_password)
  end
end
