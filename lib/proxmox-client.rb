# frozen_string_literal: true

require 'logger'

module Proxmox
  class << self
    attr_writer :logger

    def version
      @version ||= File.read(File.expand_path('../VERSION', __dir__)).strip
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.level = Logger::INFO
        log.formatter = proc do |severity, datetime, _progname, msg|
          "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity} - #{msg}\n"
        end
      end
    end
  end
end

require_relative 'proxmox/constants'
require_relative 'proxmox/connector'
require_relative 'proxmox/application'
require_relative 'proxmox/configuration'
require_relative 'proxmox/errors'
