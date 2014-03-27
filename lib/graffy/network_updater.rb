module Graffy
  class NetworkUpdater
    def update
      users.each do |id|
        update_user_network(id)
      end
    end

    def update_user_network(user_id)
      network = CalculateNetwork.new(user_id)
      Redis.current.del("2nd_degree:#{user_id}")

      if network.second_degree_connections.any?
        Redis.current.sadd("2nd_degree:#{user_id}", network.second_degree_connections)
      end

      Redis.current.del("3rd_degree:#{user_id}")

      if network.third_degree_connections.any?
        Redis.current.sadd("3rd_degree:#{user_id}", network.third_degree_connections)
      end
    end

    private

    def users
      Redis.current.smembers(USER_KEY)
    end
  end
end
