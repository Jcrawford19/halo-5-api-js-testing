require "haml"
require "json"
require "net/http"
require "pp"
require "pry"
require "sinatra"
require "sinatra/reloader"


# Api Wrapper
# -----------

module HaloApi
  class Client

    attr_accessor :api_url

    def initialize
      @api_url = "https://www.haloapi.com/{:category_type}/h5/{:category_type}/"
    end

    def get resource, category_type = "metadata"
      uri       = URI("#{@api_url}#{resource}".gsub(/{:category_type}/, category_type))
      uri.query = URI.encode_www_form({})
      request   = Net::HTTP::Get.new(uri.request_uri)
      request["Ocp-Apim-Subscription-Key"] = ENV["API_KEY"]
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request) }
      JSON.parse(response.body)
    end

  end
end


# API Endpoints
# -------------

get "/*.json" do
  content_type :json
  slug          = params[:splat].first
  category_type = slug.split("/").first
  resource      = slug.split("/").last
  HaloApi::Client.new.get(resource, category_type).to_json
end

get "/" do
  haml :app
end
