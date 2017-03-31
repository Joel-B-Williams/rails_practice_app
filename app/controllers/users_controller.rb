class UsersController < ApplicationController
  # check before routing to edit/update actions logged_in_user method (below)
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

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
      # show confirmation of update 
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  
	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    def correct_user
      # unless current_user.id == params[:id]
      #   redirect_to root_path
      # end
      @user = User.find_by(id: params[:id])
      redirect_to(root_path) unless @user == current_user
    end

end


