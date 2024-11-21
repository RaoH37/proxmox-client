# frozen_string_literal: true

module Proxmox
  class APIError < StandardError; end

  class InvalidHTTPMethod < StandardError; end

  class InvalidConfiguration < StandardError; end

  class ResourceNotFoundError < StandardError; end

  class BadParametersError < StandardError; end

  class ResourceConflictError < StandardError; end

  class NetworkError < StandardError; end

  class Forbidden < StandardError; end

  class ResourceExpiredError < StandardError; end
end
