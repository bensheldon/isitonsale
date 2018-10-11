require 'http'
require 'nokogiri'
require 'pry'

HEADER_ACCEPT = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
HEADER_USER_AGENT = 'Mozilla/5.0 My API Client'

MACYS_URL = 'https://www.macys.com/shop/product/levis-511-slim-fit-jeans-commuter?ID=2239508'

# Ensure HTTP headers are ordered alphabetically
# https://gwillem.gitlab.io/2017/05/02/http-header-order-is-important/
response = HTTP.headers(
  accept: HEADER_ACCEPT,
  'user-agent': HEADER_USER_AGENT,
).get(MACYS_URL)

document = Nokogiri::HTML response.to_s
ld_json = JSON.parse document.at_css('#productMktData').text

name = 'Commuter Jeans'
price = ld_json['offers'].first['price']
price_valid_until = ld_json['offers'].first['priceValidUntil']

form_action = 'https://docs.google.com/forms/u/1/d/e/1FAIpQLSckPXTc5-L2mu3q20aKILDTXVozP1rt8tOgOeVU2rNRMCVvPQ/formResponse'

name_name = 'entry.1966755445'
price_name = 'entry.512427736'
price_valid_until_name = 'entry.1552219756'
retailer_name = 'entry.229195637'

HTTP.post(form_action, form:
  {
    name_name => name,
    price_name => price,
    price_valid_until_name => price_valid_until,
    retailer_name => 'Macys'
  }
)