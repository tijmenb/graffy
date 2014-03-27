module Graffy
  class CalculateNetwork
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def first_degree_connections
      @first_degree ||= friends_of(user)
    end

    def second_degree_connections
      @second_degree ||= friends_of_friends - first_degree_connections - [user]
    end

    def third_degree_connections
      @third_degree ||= friends_of_second_degree - second_degree_connections - first_degree_connections - [user]
    end

    private

    def friends_of_friends
      redis_keys_for_friends = first_degree_connections.map { |id| redis_key(id) }
      if redis_keys_for_friends.any?
        Redis.current.sunion(redis_keys_for_friends)
      else
        []
      end
    end

    def friends_of_second_degree
      redis_keys_for_friend_of_friends = friends_of_friends.map { |id| redis_key(id) }
      if redis_keys_for_friend_of_friends.any?
        Redis.current.sunion(redis_keys_for_friend_of_friends)
      else
        []
      end
    end

    def friends_of(id)
      Redis.current.smembers(redis_key(id))
    end

    def redis_key(id)
      "friends_of:#{id}"
    end
  end
end
