class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		#log in
  		log_in(user)
  		redirect_to user
  	else
  		#flash.now will not carry until the next full request.  a render (as below) is not a "request" so the standard flash message carries through to the next link you visit.
			flash.now[:danger] = "Incorrect username/password combination"
  		render 'new'
  	end
  end

  def destroy
  end

end
