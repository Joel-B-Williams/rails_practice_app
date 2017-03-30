module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def current_user
		# only knows current session so does not work with cookies
		# @current_user ||= User.find_by(id: session[:user])

		# first check temp session
		if (user_id = session[:user_id]) 
			@current_user ||= User.find_by(id: user_id)
			# then check for cookie with encrypted user ID
		elsif (user_id = cookies.signed[:user_id])
			# find user by id from cookie
			user = User.find_by(id: user_id)
			# if found and authenticated by encrypted remember token, then...
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end	
	end
	
	def logged_in?
		session[:user_id]
		# !current_user.nil? <- por que no?
	end

	def log_out
		forget(current_user)
		# session[:user_id] = nil
		session.delete(:user_id)
		@current_user = nil
	end

	def remember(user)
		# create remember token & hash string in DB
		user.remember
		# store 20-year encrypted cookie to user ID
		cookies.permanent.signed[:user_id] = user.id
		# store remember token of user in cookie (not hashed because authenticate method does that for us)
		cookies.permanent[:remember_token] = user.remember_token
	end

	# to remove persisted cookie
	def forget(user)
		# call instance method forget to set DB hash-string to nil
		user.forget
		# delete relevant values from cookie
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
		# now call in log_out 
	end
end
