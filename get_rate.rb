require "garage_client"
require "twitter"
require "time"
require "dotenv"

GarageClient.configure do |c|
#  c.verbose = true
  c.endpoint = "https://bitflyer.jp"
  c.name = 'hoge'
end

client = GarageClient::Client.new(
  path_prefix: '/api'
)

res = client.get("/echo/price")

Dotenv.load
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

now = Time.now
text = ">------#{now.year.to_s}/#{now.month.to_s}/#{now.day.to_s} #{now.hour.to_s}:00のレート------>\n"
text += "1BTC = " + res.mid.to_i.to_s(:delimited) + "円\n"
text += " #bitcoin #ビットコイン #仮想通貨"

client.update(text)
