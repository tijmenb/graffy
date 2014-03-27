module Graffy
  class Connection
    attr_reader :user_a, :user_b, :recalculate

    def initialize(user_a, user_b, recalculate: false)
      @user_a = user_a
      @user_b = user_b
      @recalculate = recalculate
    end

    def exists?
      !degree.nil?
    end

    def degree
      @degree ||= find_degree
    end

    def mutual_friends
      Redis.current.sinter("friends_of:#{user_a}", "friends_of:#{user_b}")
    end

    def create
      Redis.current.pipelined do
        Redis.current.sadd("friends_of:#{user_a}", user_b)
        Redis.current.sadd("friends_of:#{user_b}", user_a)
        Redis.current.sadd(USER_KEY, [user_a, user_b])
      end
    end

    def destroy
      Redis.current.pipelined do
        Redis.current.srem("friends_of:#{user_a}", user_b)
        Redis.current.srem("friends_of:#{user_b}", user_a)
      end
    end

    private

    def find_degree
      if first_degree?
        :first_degree
      elsif second_degree?
        :second_degree
      elsif third_degree?
        :third_degree
      end
    end

    def first_degree?
      Redis.current.sismember("friends_of:#{user_a}", user_b)
    end

    def second_degree?
      network.second_degree_connections.include?(user_b)
    end

    def third_degree?
      network.third_degree_connections.include?(user_b)
    end

    private

    def network
      @network ||= (recalculate ? CalculateNetwork : Network).new(user_a)
    end
  end
end
