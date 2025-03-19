# frozen_string_literal: true

module Proxmox
  TIMEOUT = 180

  API_HTTP_METHODS = %i[get post put delete].freeze

  LOGIN_PATH = 'extjs/access/ticket'
  VERSION_PATH = 'extjs/version'
  PING_PATH = 'json/access/ticket'
end
