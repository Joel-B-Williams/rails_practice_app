class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	user = User.new(user_params)
  	if user.save
  		#displays only on the next page after success
      log_in user
      remember user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to user
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      #update user
    else
      render 'edit'
    end
  end

  private
  
	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end
end


