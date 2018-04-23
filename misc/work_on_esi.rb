require 'open-uri'
require 'pp'
require 'json'

url = 'https://esi.tech.ccp.is/latest/markets/10000002/orders/?order_type=sell&type_id=2811'

http = open( url )
p http.meta['x-pages']
p http.meta['x-esi-error-limit-remain']
p http.meta['x-esi-error-limit-reset']

result = http.read
result = JSON.parse( result )

result.each do |r|
  d = DateTime.parse( r['issued'] )
  now = (DateTime.now-0.1).to_time.utc.to_datetime
  if d > now
    p d
    p now
    p d > now
    p r
    puts
  end
end