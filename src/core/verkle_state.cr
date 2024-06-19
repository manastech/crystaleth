require "../common/types.cr"

module Pampero
  class VerkleState
    def initialize
      @state = Hash(Bytes32, Bytes32).new
    end

    def read_key(key : Bytes32) : Bytes32
      @state.fetch(key, Bytes32.new(0u8))
    end
  end
end
