require "../common/types"

module Pampero
  struct Account
    property version : UInt256?
    property balance : UInt256?
    property nonce : UInt256?
    property code_hash : Bytes32?
    property code_size : UInt256?
    property storage_root : Bytes32?

    def initialize
      # @version = UInt256.new 0
      # @balance = UInt256.new 0
      # @nonce = UInt256.new 0
      # @code_hash = Bytes32.new 0_u8
      # @code_size = UInt256.new 0_u8
      # @storage_root = Bytes32.new 0_u8
    end
  end
end
