class SessionController < ApplicationController
  #  before_filter :authorize, :except =>[:register,:login ]
 # before_filter :authorize, :only =>[:index ]
  require 'rest_client'
  require 'cas_rest_client'
  require 'json'
  require 'activerecord'
  @user=nil

  def index    #实现用户登录功能
    flash[:notice]=nil
    session[:usercookie]=nil   
    if request.post?            
      username =params[:username]
      password =params[:password]
      #登录部分代码
      begin
        # 登录接口  获取用户登录的session和用户id
        response = RestClient.post COS_URL+'/session',{'session[app_name]' => 'you','session[app_password]'=>'you_mobroad','session[username]' => username,'session[password]'=>password}
        puts response.body
        @user= JSON.parse response.body       #获取的json解析方式
        session[:usercookie]=response.cookies
        p @user['entry']['user_id']     #用户id
        p session[:usercookie]
        # 根据用户id获取个人信息  个人信息中有用户名之类的信息用于显示
        begin
          response = RestClient.get  COS_URL+'/people/'+ @user['entry']['user_id']+'/@self',{:cookies => session[:usercookie]}
          @user= JSON.parse response.body
          p @user['entry']['name']     #提取用户名称的方法
          # redirect_to(:action => "index")
          respond_to do |format|
            format.xml  { render :xml =>@user}
          end
        rescue => e
          p e
           result= JSON.parse e.response.body   #登录失败返回的错误信息
        end
      rescue =>e       
        flash[:notice]=e.to_str
      end
     
    end
  end


  def logout
    #用户注销的接口
    begin
      response = RestClient.delete  COS_URL+'/session',{:cookies => session[:usercookie]}
      puts response
    rescue => e
    
      p e
    end
   
    session[:usercookie]=nil
    redirect_to(:action => "index")
  end
  def register
    #用户注册的接口 使用session[:appcookie]作为cookie进行用户注册  注册成功后返回当前用户登录后的session和用户资料
 
 session[:appcookie]= Session.create  if !session[:appcookie]  #判断应用程序是否登录 没有的话则进行应用程序登录
   #注册接口调用和功能实现
    if request.post?  
      name =params[:name]
      password =params[:password]
      email=params[:email]     
      begin
        p session[:appcookie]
        response = RestClient.post COS_URL+"/people", {'person[username]'=>name,'person[password]'=>password,'person[email]'=> email}, {:cookies => session[:appcookie]}

        #    response= RestHelper.make_request(:post, "http://asi.mobroad.com/people", {'person[username]'=>name,'person[password]'=>password,'person[email]'=> email}, {:cookies => session[:cookie]})
        p response
        session[:appcookie]=nil
        session[:usercookie]=response.cookies
        p session[:usercookie]
        redirect_to(:action => "index")

      rescue =>e
        p e
          result= JSON.parse e.response.body   #注册失败返回的错误信息     
      end   
    end

  end
  def friendlist
    begin
      response = RestClient.get   COS_URL+'/people/bh7cj4zxSr4k3sriF8q2gB/@friends',{:cookies => session[:cookie]}
    rescue => e
      e.response
      p e
    end

    puts response
    redirect_to(:action => "index")

  end

end
