require "../common/types"

@[Link("verkle_crypto")]
lib VerkleCrypto
  fun hash(data : UInt8*) : UInt8*
end


module Pampero
  def self.hash(data : Array(UInt8)) : Bytes32
    result = VerkleCrypto.hash(data)
    Bytes32.new(0)
  end
end
