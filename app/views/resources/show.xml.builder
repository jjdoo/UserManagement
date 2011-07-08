xml.resources(:username=>params[:username]) do
   for s in @resources   
    xml.resource() do
       
      xml.resource_id(s.resource_id)
        xml.resource_type(s.resource_type)
    end
     
   # xml.error('repeat resource') if s['repeatresource']
  #  xml.success(s['success']) if s['success']
  end
end