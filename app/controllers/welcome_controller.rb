class WelcomeController < ApplicationController
  def index
  #end
  #def user_ip
    @remote_ip = request.remote_ip
    @remote_agent = request.user_agent
   # render plain: "Your ip is: #{remote_ip} \nYour agent is: #{remote_agent}"
  end
end

