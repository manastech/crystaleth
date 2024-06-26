require "../common/types"

@[Link("verkle_crypto")]
lib VerkleCrypto
  fun create_context() : UInt8*
  fun hash(context : UInt8*, data : UInt8*, output : UInt8*)
end


module Pampero
  def self.hash(data : Array(UInt8)) : Bytes32
    context = VerkleCrypto.create_context()
    result = VerkleCrypto.hash(context, data)
    Bytes32.new(0)
  end
end
