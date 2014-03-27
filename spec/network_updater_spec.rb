require "spec_helper"

describe Graffy::NetworkUpdater do
  describe ".update" do
    it "updates the network" do
      create_friendships ['bill', 'peter'], ['bill', 'albert'], ['albert', 'john'], ['john', 'cindy']
      Graffy::NetworkUpdater.new.update

      network = Graffy::CalculateNetwork.new('bill')
      cached_network = Graffy::Network.new('bill')

      expect(cached_network.first_degree_connections).to eq network.first_degree_connections
      expect(cached_network.second_degree_connections).to eq network.second_degree_connections
      expect(cached_network.third_degree_connections).to eq network.third_degree_connections
    end
  end
end
