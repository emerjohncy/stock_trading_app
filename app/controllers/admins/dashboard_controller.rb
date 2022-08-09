class Admins::DashboardController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]
  
  def index
    @users = User.all
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
    if @user.update(user_params)
      flash[:notice] = "Account has been created successfully"
      redirect_to @user
    else
      flash.now[:alert] = "Something went wrong"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
