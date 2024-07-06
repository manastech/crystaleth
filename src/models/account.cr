require "../common/types"

module Pampero
  struct Account
    property version : UInt256?
    property balance : UInt256?
    property nonce : UInt256?
    property code_hash : Bytes32?
    property code_size : UInt256?
    property storage_root : Bytes32?

    def initialize(
      @version : UInt256? = nil,
      @balance : UInt256? = nil,
      @nonce : UInt256? = nil,
      @code_hash : Bytes32? = nil,
      @code_size : UInt256? = nil,
      @storage_root : Bytes32? = nil
    )
    end
  end
end
