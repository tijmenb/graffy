require 'graffy'
require 'support/friendship_helper'

RSpec.configure do |config|
  config.include FriendshipHelper

  config.order = 'random'

  config.before(:each) do
    Redis.current.select 9
    Redis.current.flushdb
  end
end
