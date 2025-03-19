# frozen_string_literal: true

module Proxmox
  class Application
    attr_accessor :csrf, :ticket
    attr_reader :connector, :username, :role

    def initialize
      yield(configuration) if block_given?
      @connector = Connector.new(self)
      @csrf = nil
      @ticket = nil
      @username = nil
      @role = nil
    end

    def configuration(&block)
      @configuration ||= Configuration.new(&block)
    end

    def login
      response = connector.post(LOGIN_PATH, need_auth: false, data: configuration.credentials_params)
      update_tokens(response[:data])
    end

    def version
      response = connector.get(VERSION_PATH, data: { _dc: (Time.now.to_f * 1_000).to_i })
      response.dig(:data, :version)
    end

    def ping
      response = connector.post(PING_PATH, data: { username: @username, password: @ticket })
      update_tokens(response[:data])
    end

    private

    def update_tokens(data)
      @csrf = data[:CSRFPreventionToken]
      @ticket = data[:ticket]
      @username = data[:username]
      @role = data[:role]
    end
  end
end
