module Graffy
  class Network
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def first_degree_connections
      CalculateNetwork.new(user).first_degree_connections
    end

    def second_degree_connections
      Redis.current.smembers("2nd_degree:#{user}")
    end

    def third_degree_connections
      Redis.current.smembers("3rd_degree:#{user}")
    end
  end
end
