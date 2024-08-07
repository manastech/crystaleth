module Pampero

  class Config
    getter beacon_node : String

    def initialize
      @beacon_node = ENV["BEACON_NODE"] || ""
    end
  end
end
