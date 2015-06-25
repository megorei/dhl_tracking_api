class DhlTrackingApi
  class ApiWrapper
    ApiBaseUrl    = 'https://nolb.dhl.de/nextt-online-business'
    ApiBasePath   = '/direct/nexttjlibpublicservlet?xml='
    RequestMethod = 'd-get-piece-detail' # d-get-piece

    attr_reader :response, :error_message

    def process(tracking_code)
      @response, @error_message = nil, nil
      begin
        sess            = Patron::Session.new
        sess.base_url   = ApiBaseUrl
        @response       = sess.get( build_request_path(tracking_code) )
        @error_message  = @response.status_line if @response.status != 200
      # rescue => e
      #   @error_message = e.message
      end
    end

    # d-get-piece-detail
    def build_request_path(tracking_code)
      ApiBasePath + URI.escape(
        '<?xml version="1.0" encoding="ISO-8859-1"?>' +
        '<data appname="%s" password="%s" language-code="de" request="%s" piece-code="%s"></data>' % [
          DhlTrackingApi.config.username, DhlTrackingApi.config.password, RequestMethod, tracking_code
        ])
    end
  end

end
