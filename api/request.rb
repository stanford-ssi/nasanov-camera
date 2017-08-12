require 'http'

module HABMC

  class HABMCRequest

    attr_accessor :request

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
        },
        missions: {
            path: '/missions.json',
            type: 'get'
        }
    }.each do |name, params|
      define_method name do
        @request.send(params[:type], prepare(params[:path]))
      end
    end

    def prepare(path)
      path = "/#{path}" unless path[0] == '/'

      "https://habmc.stanfordssi.org#{path}"
    end
  end

end
