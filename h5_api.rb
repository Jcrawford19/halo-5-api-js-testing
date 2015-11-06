require "json"
require "net/http"
require "pp"
require "pry"
require "sinatra"

# Api Wrapper
# -----------

module HaloApi
  class Client

    attr_accessor :api_url

    def initialize
      @api_url = "https://www.haloapi.com/metadata/h5/"
    end

    def get slug
      api_endpoint = "#{@api_url}#{slug}"
      uri = URI(api_endpoint)
      uri.query = URI.encode_www_form({})

      request = Net::HTTP::Get.new(uri.request_uri)
      request["Ocp-Apim-Subscription-Key"] = ENV["API_KEY"]
      #request.body = "{body}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        p "http.request"
        http.request(request)
      end

      JSON.parse(response.body)
    end

  end
end


# API Endpoints
# -------------

get "*.json" do
  content_type :json

  slug = params[:splat].first
  pp params[:splat]
  p "Route: #{slug}"

  client = HaloApi::Client.new
  client.get(slug).to_json
end
