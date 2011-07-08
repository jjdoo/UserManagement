class Session < ActiveRecord::Base
require 'json'
  @@app_password = APP_CONFIG[:asi_app_password]
  @@app_name = APP_CONFIG[:asi_app_name]
  @@cookie = nil
 
  def self.create
    @headers = {}
    params = {:session => {}}
    params[:session][:username] = @username if @username
    params[:session][:password] = @password if @password
    params[:session][:app_name] = @@app_name
    params[:session][:app_password] = @@app_password
    begin
      resp =  RestClient.post(COS_URL+'/session', {'session[app_name]' =>   params[:session][:app_name],'session[app_password]'=> params[:session][:app_password] = @@app_password})
    rescue => e
      p e      #try again
      resp =  RestClient.post(COS_URL+'/session', params.to_json)
    end
    @headers["Cookie"] = resp.cookies
#   session[:appcookie]= @headers["Cookie"]
#  p   session[:appcookie]
#    json = JSON.parse(resp.body)
#    @person_id = json["entry"]["user_id"] if @username
  end

end
