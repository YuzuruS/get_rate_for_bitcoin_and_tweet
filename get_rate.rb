require "rest-client"
require "twitter"
require "time"
require "dotenv"
require "garage_client"

def create_text(rate_name, rate)
  "1#{rate_name} = " + rate + "円\n"
end

def tweet(text)
  Dotenv.load File.expand_path(File.dirname($0)) + '/.env'
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end

  client.update(text)
end

res = RestClient.get 'https://bitflyer.jp/api/echo/price'
res = JSON.parse(res.body)

now = Time.now
text = "#{now.year.to_s}/#{now.month.to_s}/#{now.day.to_s} #{now.hour.to_s}:00のレート\n"
text += create_text 'BTC', res['mid'].to_i.to_s(:delimited)

res = RestClient.get 'http://api.aoikujira.com/kawase/json/JPY'
res = JSON.parse(res.body)

%w(USD EUR GBP).each { |rate|
  text += create_text rate, (1/res[rate].to_f).round(2).to_s
}

text += "#ビットコイン #為替レート #FX"
tweet text
