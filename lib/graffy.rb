require "redis"
require_relative "graffy/version"
require_relative "graffy/network"
require_relative "graffy/connection"

require_relative "graffy/network_updater"
require_relative "graffy/calculate_network"

module Graffy
  USER_KEY = 'users'
end
