## Graffy

Abstraction layer for a small social network graph built on top of Redis.

Note that we use 'friends' here, but it could just as easily be any other type
of node. Graffy uses strings for node identifiers.

## Usage

### Graffy::Connection

Use `Graffy::Connection` to create connections.

```ruby
# Create a connection between two people:
Graffy::Connection.new(user_id, friend_id).create

# And destroy it:
Graffy::Connection.new(user_id, friend_id).destroy
```

Use it to explore connections:

```ruby
# how are the users connected?
# returns nil, :first_degree, :second_degree or :third_degree
Graffy::Connection.new(user_id, other_user_id).degree

# are the users connected at all?
Graffy::Connection.new(user_id, other_user_id).exists?

# array of mutual friends
Graffy::Connection.new(user_id, other_user_id).mutual_friends
```

### Graffy::NetworkUpdater

If you'd like to work with second- and third-degree connections, we first have to
cache those by running the network updater:

```ruby
Graffy::NetworkUpdater.new.update
```

Do this in a background or cron job. After that you can use:

### Graffy::Network

```ruby
# get all the friends of the user
Graffy::Network.new(user_id).first_degree_connections

# get all the friends-of-friends of the user
Graffy::Network.new(user_id).second_degree_connections

# get all the friends-of-friends-of-friends of the user
Graffy::Network.new(user_id).third_degree_connections
```
