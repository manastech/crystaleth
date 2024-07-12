require "../common/types"
require "../common/constants"

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

    def contract?
      (@code_hash != nil && @code_hash != Pampero::KECCAK256_NULL) || (@code_size != nil && @code_size != 0)
    end
  end
end
