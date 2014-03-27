require "spec_helper"

describe Graffy::CalculateNetwork do
  describe "#first_degree_connections" do
    it "is empty if the user has no friends" do
      network = Graffy::CalculateNetwork.new('bill')
      expect(network.first_degree_connections).to match_array []
      expect(network.second_degree_connections).to match_array []
      expect(network.third_degree_connections).to match_array []
    end

    it "is an array of friends" do
      create_friendships ['bill', 'peter'], ['bill', 'john'], ['john', 'peter'], ['john', 'albert']

      network = Graffy::CalculateNetwork.new('bill')
      expect(network.first_degree_connections).to match_array ["peter", "john"]
    end

    it "returns empty array if the user has no friends" do
      network = Graffy::CalculateNetwork.new(15)
      expect(network.first_degree_connections).to be_empty
    end
  end

  describe "#second_degree" do
    it "returns the friends of friends, but not friends" do
      create_friendships ['bill', 'peter'], ['bill', 'john'], ['john', 'albert']

      network = Graffy::CalculateNetwork.new('bill')
      expect(network.second_degree_connections).to eq ['albert']
    end

    it "is empty if the user has no friends" do
      network = Graffy::CalculateNetwork.new('bill')
      expect(network.second_degree_connections).to match_array []
    end
  end

  describe "#third_degree" do
    it "returns the friends of friends of friends, but not friends and fofs" do
      create_friendships ['bill', 'peter'], ['bill', 'john'], ['john', 'albert'], ['albert', 'cindy']

      network = Graffy::CalculateNetwork.new('bill')
      expect(network.third_degree_connections).to match_array ['cindy']
    end

    it "is empty if the user has no friends" do
      network = Graffy::CalculateNetwork.new('bill')
      expect(network.third_degree_connections).to match_array []
    end
  end
end
