require "spec_helper"

describe Graffy::Connection do

  before do
    create_friendship 'john', 'albert'
    create_friendship 'albert', 'cindy'
    create_friendship 'cindy', 'jefferson'
    Graffy::NetworkUpdater.new.update
  end

  describe "#exists?" do
    it "is true if the user is a friend" do
      connection = Graffy::Connection.new('john', 'albert')
      expect(connection.exists?).to be_true
    end

    it "is true if the user is a friend of a friend" do
      connection = Graffy::Connection.new('john', 'cindy')
      expect(connection.exists?).to be_true
    end

    it "is true if the user is a friend of a friend's friend" do
      connection = Graffy::Connection.new('john', 'jefferson')
      expect(connection.exists?).to be_true
    end

    it "is false if the user is a not connected at all" do
      connection = Graffy::Connection.new('john', 'someone-else')
      expect(connection.exists?).to be_false
    end
  end

  describe "#create" do
    it "creates a friendship" do
      connection = Graffy::Connection.new(1, 2)
      connection.create
      expect(connection.exists?).to be_true
    end
  end

  describe "#destroy" do
    it "destroys a friendship" do
      friendship = create_friendship
      friendship.destroy
      expect(friendship.exists?).to be_false
    end
  end

  describe "#degree" do
    it "is 'first_degree' if the user is a friend" do
      connection = Graffy::Connection.new('john', 'albert')
      expect(connection.degree).to be(:first_degree)
    end

    it "is 'second_degree' if the user is a friend of a friend" do
      connection = Graffy::Connection.new('john', 'cindy')
      expect(connection.degree).to be(:second_degree)
    end

    it "is 'third_degree' if the user is a friend of a friend's friend" do
      connection = Graffy::Connection.new('john', 'jefferson')
      expect(connection.degree).to be(:third_degree)
    end

    it "is 'none' if the user is a friend of a friend's friend" do
      connection = Graffy::Connection.new('john', 'someone-else')
      expect(connection.degree).to be_nil
    end
  end

  describe "#mutual_friends" do
    it "returns mutual friends for two users" do
      connection = Graffy::Connection.new('john', 'cindy')
      expect(connection.mutual_friends).to match_array %w[albert]
    end

    it "is empty if the users have no mutual friends" do
      connection = Graffy::Connection.new('john', 'jefferson')
      expect(connection.mutual_friends).to match_array []
    end
  end
end
