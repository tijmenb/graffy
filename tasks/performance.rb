require 'graffy'
require 'benchmark'

namespace :performance do
  POPULATION = 1_000
  AVERAGE_FRIEND_COUNT = 10

  def random_user
    user_ids.sample
  end

  def user_ids
    @user_ids ||= (1..POPULATION).to_a
  end

  def select_database
    Redis.current.select 3
  end

  desc 'Set up test users'
  task :setup do
    select_database
    Redis.current.flushdb

    def random_friend_count
      (0..AVERAGE_FRIEND_COUNT).to_a.sample
    end

    relationships = 0

    user_ids.each do |user_id|
      user_ids.sample(random_friend_count).each do |friend_id|
        Graffy::Connection.new(user_id, friend_id).create
        relationships += 1
      end
    end

    puts "Created #{POPULATION} users with #{relationships} total relationships"
  end

  desc 'Run test without cache'
  task :test do
    select_database

    n = (ENV['I'] || 100).to_i

    puts "Number of requests per degree: #{n}"

    first = Benchmark.measure { n.times { Graffy::CalculateNetwork.new(random_user).first_degree_connections } }.real
    puts "1st degree: #{first}s, #{(first/n) * 1000}ms per call"

    second = Benchmark.measure { n.times { Graffy::CalculateNetwork.new(random_user).second_degree_connections } }.real
    puts "2nd degree: #{second}s, #{(second/n) * 1000}ms per call"

    third = Benchmark.measure { n.times { Graffy::CalculateNetwork.new(random_user).third_degree_connections } }.real
    puts "3rd degree: #{third}s, #{(third/n) * 1000}ms per call"
  end

  namespace :cache do
    desc 'Update the network cache'
    task :setup do
      select_database
      t = Benchmark.measure { Graffy::NetworkUpdater.new.update }
      puts "Updated network in #{t.real.round(2)} seconds"
    end

    desc 'Run the network test with cache'
    task :test do
      n = (ENV['I'] || 100).to_i

      puts "Number of requests per degree: #{n}"

      first = Benchmark.measure { n.times { Graffy::Network.new(random_user).first_degree_connections } }.real
      puts "1st degree: #{first}s, #{(first/n) * 1000}ms per call"

      second = Benchmark.measure { n.times { Graffy::Network.new(random_user).second_degree_connections } }.real
      puts "2nd degree: #{second}s, #{(second/n) * 1000}ms per call"

      third = Benchmark.measure { n.times { Graffy::Network.new(random_user).third_degree_connections } }.real
      puts "3rd degree: #{third}s, #{(third/n) * 1000}ms per call"
    end
  end
end
