module UsersHelper
	
	#gravatar uses MD5 hashing (hashing the email)
	#You do an MD5 hash in rails thusly...
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
	#note MD5 is case sensitive so we've downcased the email here
end
