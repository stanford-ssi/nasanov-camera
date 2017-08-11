
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

    def video_started_for(mission_id)
      req = habmc

      validate_response! req.request.post(req.prepare "/nasanov/#{mission_id}")
    end

    def missions
      json_response(habmc.missions)['missions'].map do |json|
        Model.new json
      end
    end

    private

    def habmc
      HABMCRequest.new @api_key
    end

    def validate_response!(response)
      unless response.code.to_i == 200
        raise "Invalid response code #{response.code}"
      end
    end


    def json_response(response)
      validate_response! response

      JSON(response.body)
    end

  end

end
