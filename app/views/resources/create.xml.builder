xml.status() do
  for s in @statuses
    xml.repeat(s['repeatresource']) if s['repeatresource']
   # xml.error('repeat resource') if s['repeatresource']
    xml.success(s['success']) if s['success']
  end
end