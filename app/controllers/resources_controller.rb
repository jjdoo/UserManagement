require 'json'
require 'crack'

class ResourcesController < ApplicationController


  # GET /manage/devices.json?user=thisisusername
  # 格式参考 SVN的RRE/public/format/device.json
  def list_devices
    username = params[:user]
#    if params[:resource_type]
#      resource_type =params[:resource_type]
#      @resources = Resource.find(:all,
#        :conditions =>["username = ? AND resource_type= ? ",username,resource_type])
#    else
#      @resources = Resource.find(:all,
#        :conditions =>["username = ?  ",username])
#    end
    render_array = []
    sensor_array = []
    gateway_array=[]
    
    @resources.each  do |resource|
     begin
     response = RestClient.get  GateWay_URL+'/Registrar/servlet/Registrar?GW='+resource[:resource_id].split(":")[0]+resource[:resource_id].split(":")[1]
     sensor = JSON.parse response.body
#     gateway['sensors'].each do |sensor|
#     sensor_array  << {:sensorID=>sensor['sensorID'],:type =>sensor['type'],:status =>sensor['status'] } if sensor['owner']= username
     sensor_array << {:id=>gateway[:id], :title=>gateway[:title],:status=>gateway[:status],:sensors=>sensor_array}

    rescue => e
      p e
    end
#      begin
#     response = RestClient.get  GateWay_URL+'/Registrar/servlet/Registrar?GW='+resource[:resource_id].split(":")[0]+"&sensor="+resource[:resource_id].split(":")[1]
#     sensor= JSON.parse response.body
#     sensor_array << {:sensorID=>sensor['sensorID'],:type =>sensor['type'],:status =>sensor['status'] }
#
#    rescue => e
#      p e
#    end

  end

  #    render_array = []
  #    gateways = Resource.find(:all, :conditions=>{:username => username, :resource_type=> "gateway"})
  #    p gateways
  #
  #     sensors = Resource.find(:all, :conditions=>{:username => username, :resource_type=> "sensor" })
  #     sensor_array = []
  #     sensors.each do |sensor|
  #      sensor_array << {:sensor_id=>sensor[:resource_id]}
  #     end

    
  #    gateways.each do |gateway|
  #      sensors = Resource.find(:all, :conditions=>{:username => username, :resource_type=> "sensor", :resource_id.split(":")[0] => gateway[:resource_id] })
  #      sensor_array = []
  #      sensors.each do |sensor|
  #        sensor_array << {:sensor_id=>sensor[:resource_id]}
  #      end
  #      render_array << {:gateway_id=>gateway[:resource_id], :sensors=>sensor_array}
  #    end
 render :json=>gateway_array
end


# GET /resources
# GET /resources.xml  
def index
  @resources = Resource.all
  #  check_username
  # create_session
  p session[:usercookie]
  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @resources }
  end
end

# GET /resources/1
# GET /resources/1.xml
def show
  if params[:resource_type]
    resource_type=params[:resource_type]
  else
    resource_type='%'
  end
  p  params[:username]
  @resources = Resource.find(:all,
    :conditions =>["username = ?  ",params[:username]])
  # :conditions =>["username = ?",params[:id]])
 
  respond_to do |format|
    #  format.html # show.html.erb
    format.xml
  end
end

# GET /resources/new
# GET /resources/new.xml
def new
  @resource = Resource.new

  respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @resource }
  end
end

# GET /resources/1/edit
def edit
  @resource = Resource.find(params[:id])
end

# POST /resources
# POST /resources.xml
def create
   
  #   @resources2 = Resource.all
  @resources= Resource.all
   
  @statuses=[]
  #    # if params{:username}
  #    #  repeat_resouce= @resources.find{|item| item.resouce_id ==params{:resource_id}}
  #    #    if !repeat_resouce
  #
  #    #  else
  #    p params{:username}
  #    @resource.username = params[:username]
  #    @resource.resouce_id = params[:resource_id]
  #    @resource.resouce_type = params[:resource_type]
  #  end
  #   end

  resource_xml = params[:text]
  p resource_xml
  hash = Crack::XML.parse resource_xml
  arr = hash['items']['resource']

  p resource_xml
  p arr
  arr.each do |temp|
    #用来检查是否重复设置了同一resource
    @resources= Resource.all
    @repeat_resource= @resources.find{|item| item.resource_id == temp['resource_id']}
    if @repeat_resource
      @status={}
      @status['repeatresource']= temp['resource_id']
      @statuses.push(@status)
    else
      if(temp['username']&& temp['resource_id']&&temp['resource_type'] )
        @resource = Resource.new(params[:resource])
        @resource.username = temp['username'] 
        @resource.resource_id = temp['resource_id']
        @resource.resource_type = temp['resource_type'] 
        @resource.save
        @status={}
        @status['success']= temp['resource_id']
        @statuses.push(@status)
      else
        @status={}
        @status['errorparams']= temp['resource_id']
        @statuses.push(@status)
      end
    end
  end
  respond_to do |format|
   
    #  if @resource.save
    #  format.html { redirect_to(@resource, :notice => 'Resource was successfully created.') }
    #   format.xml  { render :xml => @resource, :status => :created, :location => @resource }
    #   format.xml  { render :xml => {:status=>@statuses} }
    format.xml
    #   format.xml  { render :xml => {@resource}}
    #      else
    #        format.html { render :action => "new" }
    #        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
    #      end
     
  end
end

# PUT /resources/1
# PUT /resources/1.xml
def update
  @resource = Resource.find(params[:resource_id])

  respond_to do |format|
    @resource.update_attribute('resource_id',params[:new_resource_id] )
    if @resource.update_attributes(params[:resource])
      #  format.html { redirect_to(@resource, :notice => 'Resource was successfully updated.') }
      format.xml  { render :xml =>{"status"=>'success'}}
    else
      #    format.html { render :action => "edit" }
      format.xml  { render :xml =>{"status"=>'fail'}}
    end
  end
end

# DELETE /resources/1
# DELETE /resources/1.xml
def destroy
  @resource = Resource.find(params[:resource_id])
  @resource.destroy

  respond_to do |format|
    # format.html { redirect_to(resources_url) }
    format.xml  {render :xml =>{"status"=>'delete'}}
  end
end


def check_username 

  #session[:appcookie]=nil
  name = params[:username]
  session[:appcookie]= Session.create  if !session[:appcookie]

  begin
    response = RestClient.post COS_URL+"/people", {'person[username]'=>name}, {:cookies => session[:appcookie]}
    session[:usercookie]=response.cookies
    session[:appcookie]=nil
    redirect_to(:action => "index")

  rescue =>e
    p e
    #    flash[:notice]="用户名或邮箱已注册！"
    check_result= JSON.parse e.response.body
    p check_result['messages'][1]
    check_result=check_result['messages'][1]
    if check_result=="Username has already been taken"
      @check_result= 'Username is right'
    else if check_result=="Password is too short"
        @check_result= 'Username does not exist'
      else
        @check_result= 'Internal error, please try again'
      end
    end
    respond_to do |format|
      
      format.xml
    end
  end
end

end
