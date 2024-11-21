# frozen_string_literal: true

module Proxmox
  class Connector
    def initialize(application)
      @application = application
    end

    def get(path, data: {}, need_auth: true, headers: {})
      call(:get, path, data:, need_auth:, headers:)
    end

    def put(path, data: {}, need_auth: true, headers: {})
      call(:put, path, data:, need_auth:, headers:)
    end

    def post(path, data: {}, need_auth: true, headers: {})
      call(:post, path, data:, need_auth:, headers:)
    end

    def delete(path, need_auth: true, headers: {})
      call(:delete, path, need_auth:, headers:)
    end

    def call(method, path, data: {}, need_auth: true, headers: {})
      raise InvalidHTTPMethod, "invalid http method #{method}" unless API_HTTP_METHODS.include?(method)

      url = compute_url(path)
      body = +''

      unless data.empty?
        case method
        when :get
          params = URI.encode_www_form(data)
          url << "?#{params}"
        when :post
          body << URI.encode_www_form(data)
        when :put
          body << URI.encode_www_form(data)
        when :delete
          params = URI.encode_www_form(data)
          url << "?#{params}"
        end
      end

      if need_auth
        headers.merge!({ 'Cookie' => "PMGAuthCookie=#{@application.ticket}", 'CSRFPreventionToken' => @application.csrf })
      end

      do_request(method, url, body:, headers:)
    end

    private

    def compute_url(path)
      File.join(@application.configuration.endpoint, @application.configuration.base_path, path)
    end

    def default_headers
      @default_headers ||= { 'User-Agent' => Proxmox.name }
    end

    def do_request(method, url, body: nil, params: nil, headers: {})
      conn = Faraday.new(
        url:,
        headers: headers.merge(default_headers),
        request: {
          timeout: TIMEOUT
        },
        ssl: @application.configuration.ssl_options
      ) do |faraday|
        faraday.response :logger, nil, { headers: true, bodies: true, errors: true } if @application.configuration.verbose
      end

      response = conn.run_request(method, url, body, headers) do |request|
        request.params.update(params) if params
      end

      do_response(response)

    rescue Faraday::SSLError => e
      raise APIError, e.message
    end

    def do_response(response)
      result = JSON.parse(response.body, symbolize_names: true)

      if response.status >= 100 && response.status < 300
        result
      elsif response.status == 403
        raise Forbidden, result
      elsif response.status == 404
        raise ResourceNotFoundError, result
      elsif response.status == 400
        raise BadParametersError, result
      elsif response.status == 409
        raise ResourceConflictError, result
      elsif response.status == 460
        raise ResourceExpiredError, result
      elsif response.status.zero?
        raise NetworkError
      else
        raise APIError, result
      end
    end
  end
end
