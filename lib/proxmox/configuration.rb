# frozen_string_literal: true

module Proxmox
  class Application
    class Configuration
      attr_accessor :endpoint, :base_path, :username, :password, :realm, :verbose

      def initialize
        @endpoint = nil
        @base_path = nil
        @username = nil
        @password = nil
        @realm = nil
        @verbose = false
      end

      def credentials_params
        {
          username: @username,
          password: @password,
          realm: @realm
        }
      end

      def ssl_options
        {
          verify: false,
          verify_hostname: false,
          verify_mode: OpenSSL::SSL::VERIFY_NONE
        }
      end

      def load_from_hash(hash)
        raise InvalidConfiguration, 'Invalid configuration hash' if hash.empty?

        @endpoint = hash[:endpoint]
        @base_path = hash[:base_path]
        @username = hash[:username]
        @password = hash[:password]
        @realm = hash[:realm]
      end

      def load_from_path(path)
        raise InvalidConfiguration, "no such file #{path}" unless File.exist?(path)

        hash = JSON.parse(File.read(path), symbolize_names: true)

        load_from_hash(hash)
      end
    end
  end
end
