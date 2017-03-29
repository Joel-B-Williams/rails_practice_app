module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user])
	end
	
	def logged_in?
		session[:user_id]
		# !current_user.nil?
	end

	def log_out
		# session[:user_id] = nil
		session.delete(:user_id)
		@current_user = nil
	end

end
