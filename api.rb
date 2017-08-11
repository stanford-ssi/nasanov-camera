require 'http'

module HABMC

  class Client

    def initialize(api_key)
      @api_key = api_key
    end

    def livestream_url
      return @livestream_url unless @livestream_url.nil?

      @livestream_url = json_response(habmc.livestream_url)['url']
    end

    def livestream_key
      return @livestream_key unless @livestream_key.nil?

      @livestream_key = json_response(habmc.livestream_key)['key']
    end

    def set_video_id(mission_id:, video_id:)

    end

    private

    def habmc
      HABMCRequest.new @api_key
    end

    def json_response(response)
      unless response.code.to_i == 200
        raise "Invalid response code #{response.code}"
      end

      JSON(response.body)
    end

  end

  class HABMCRequest

    def initialize(api_key)
      @request = HTTP.auth("Bearer #{api_key}")
    end

    {
        livestream_url: {
            path: '/nasanov/url',
            type: 'get'
        },
        livestream_key: {
            path: '/nasanov/key',
            type: 'get'
        }
    }.each do |name, params|
      define_method name do
        @request.send(params[:type], prepare(params[:path]))
      end
    end

    def prepare(path)
      path = "/#{path}" unless path[0] == '/'

      "http://localhost:3000#{path}"
    end
  end

end
