class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :upload]
  before_action :require_user, only: [:edit, :update, :upload]
  before_action :require_same_user, only: [:edit, :update, :upload]

  def index
    @users = User.paginate(page: params[:page], per_page: 12)
  end

  def new 
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Alpha-Blog, #{@user.username}!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "Your Account updated successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 8)
  end

  def upload
    if @user.update(avatar_param)
    flash[:success] = "Your Avatar updated successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def avatar_param
    params.require(:user).permit(:avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    unless logged_in? && current_user == @user
      flash[:danger] = "You can only edit your Account"
      redirect_to user_path(@user)
    end
  end
end