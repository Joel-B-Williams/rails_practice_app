class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # helpers for sessions will now be available in all controllers
  include SessionsHelper
  # def hello
  # 	render html: "Hello, World!"
  # end
end
