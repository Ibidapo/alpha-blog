class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back #{user.username}!"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "Incorrect login credentials"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "We look forward to seeing you again :("
    redirect_to root_path
  end
end
