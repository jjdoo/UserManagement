xml.username(:username=>params[:username]) do
  
    xml.status(@check_result)
   # xml.error('repeat resource') if s['repeatresource']
  #  xml.success(s['success']) if s['success']

end