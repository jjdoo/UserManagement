require "net/https"
require "uri"
require "rubygems"
require "active_support"

module Http
  
  class Base

    def initialize(options)
      @options = options
      @uri = URI.parse(@options[:uri])
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @method = @options[:method] ? @options[:method] : :get
      self.send "#{@method}_request"
      @request.basic_auth(@options[:username],@options[:password]) if @options[:auth]
      @http.use_ssl = true if @uri.scheme == "https"
    end

    def response
      @http.start.request(@request)
#      p res.header.code
#      p res.body
    end

    def get_request
      puts "get"
      @request = Net::HTTP::Get.new @uri.request_uri
      @request["Accept"] = @options[:accept_type] if @options[:accept_type]
    end

    def post_request
      puts "post"
      @request = Net::HTTP::Post.new @uri.request_uri
      @request.set_form_data(@options[:post_data]) if @options[:post_data]
      @request["Content-Type"] = @options[:content_type] if @options[:content_type]
    end

    def delete_request
      puts "delete"
      @request = Net::HTTP::Delete.new @uri.request_uri
    end

  end
  
end

##registrationStatus
#registration_status = {
#  :auth => true,
#  :username => "zhouyezhouye",
#  :password => "atlantis",
#  :method => "get",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/registration"
#}
##rw_registration_status = Mjcf::Base.new registration_status
##rw_registration_status.response

##register
#register = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "post",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/registration"
#}
#rw_register = Mjcf::Base.new register
#rw_register.response

##unregister
#unregister = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "delete",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/registration"
#}
#rw_unregister = Mjcf::Base.new unregister
#rw_unregister.response

###################### MESSAGE ##################################################

###getMessagesXml
#get_messages_xml = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "get",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/im",
#  :accept_type => "application/xml"
#}
#rw_get_messages_xml = Mjcf::Base.new get_messages_xml
#rw_get_messages_xml.response

##getMessagesJson
#get_messages_json = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "get",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/im",
#  :accept_type => "application/json"
#}
#rw_get_messages_json = Mjcf::Base.new get_messages_json
#p rw_get_messages_json.response.body

##sendMessage
#send_message = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "post",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/im/gcchenzhen@imsinnovation.com",
#  :post_data => "second this ttt",
#  :content_type => "text/plain"
#}
#rw_send_message = Mjcf::Base.new send_message
#rw_send_message.response

###################### PRESENSE ##################################################

##publicationStatus
#publication_status = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "get",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/users/gcchenzhen@imsinnovation.com/presence",
#}
#rw_publication_status = Mjcf::Base.new publication_status
#rw_publication_status.response

##deletePublication
#delete_publication = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "delete",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/users/gcchenzhen/presence",
#}
#rw_delete_publication = Mjcf::Base.new delete_publication
#rw_delete_publication.response

##publishPresence
#publish_presence = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "post",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/users/gcchenzhen/presence",
#  :post_data => '<presence xmlns:rpid="urn:ietf:params:xml:ns:pidf:rpid" xmlns:gp="urn:ietf:params:xml:ns:pidf:geopriv10" xmlns:pt="urn:ietf:params:xml:ns:location-type" xmlns:pdm="urn:ietf:params:xml:ns:pidf:data-model" xmlns="urn:ietf:params:xml:ns:pidf" entity="sip:gcchenzhen@imsinnovation.com"  xmlns:other="urn:other" xmlns:cl="urn:ietf:params:xml:ns:pidf:geopriv10:civicLoc" xmlns:gml="urn:opengis:specification:gml:schema-xsd:feature:v3.0">  <pdm:person id="p1">    <rpid:mood>     <rpid:happy />    </rpid:mood>    <rpid:place-type>     <pt:airport />      <pt:cafe />   </rpid:place-type>    <gp:geopriv>      <gp:location-info>        <cl:civicAddress>         <cl:country>SE</cl:country>         <cl:A3>Stockholm</cl:A3>          <cl:PC>00100</cl:PC>        </cl:civicAddress>        <gml:location>          <gml:Point srsName="epsg:4326" gml:id="Point1">           <gml:coordinates>37:46:30N 122:25:10W</gml:coordinates>         </gml:Point>        </gml:location>     </gp:location-info>     <gp:usage-rules />    </gp:geopriv>   <pdm:note>Hello world!</pdm:note>   <pdm:timestamp>2009-04-13T08:21:13.75Z</pdm:timestamp>  </pdm:person> </presence> ',
#  :content_type => "application/pidf+xml"
#}
#rw_publish_presence = Mjcf::Base.new publish_presence
#rw_publish_presence.response

#########################################################################
##getPeerPresentityListsJson  //all lists
#get_peerPresentity_lists = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "get",
#  :content_type => "application/json",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/users/gcchenzhen/friendlists",
#}
#rw_get_peerPresentityLists = Mjcf::Base.new get_peerPresentity_lists
#rw_get_peerPresentityLists.response

##getPeerPresentityListJson //buddies of one list
#get_peerPresentity_list = {
#  :auth => true,
#  :username => "gcchenzhen",
#  :password => "chenzhen",
#  :method => "get",
#  :content_type => "application/json",
#  :uri => "https://provisioning.imsinnovation.com/imsrest/jersey/users/gcchenzhen/friendlists/myBuddies,",
#}
#rw_get_peerPresentityList = Mjcf::Base.new get_peerPresentity_list
#p rw_get_peerPresentityList.response.body