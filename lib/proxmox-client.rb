# frozen_string_literal: true

require 'faraday'
require 'json'
require 'logger'
require 'openssl'
require 'uri'

module Proxmox
  class << self
    def version
      @version ||= File.read(File.expand_path('../VERSION', __dir__)).strip
    end

    def name
      @name ||= 'proxmox-client'
    end

    def logger
      @logger || logger!
    end

    def logger!(path = $stdout)
      @logger = Logger.new(path)
      @logger.level = Logger::INFO
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity} - #{msg}\n"
      end
      @logger
    end

    attr_writer :logger
  end
end

require_relative 'proxmox/constants'
require_relative 'proxmox/connector'
require_relative 'proxmox/application'
require_relative 'proxmox/configuration'
require_relative 'proxmox/errors'
