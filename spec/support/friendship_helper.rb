module FriendshipHelper
  def create_friendship(a = 'bill', b = 'john')
    friendship = Graffy::Connection.new(a, b)
    friendship.create
    friendship
  end

  def create_friendships(*tuples)
    tuples.each { |(a,b)| create_friendship(a, b) }
  end
end
