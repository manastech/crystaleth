require "../common/types"

@[Link("verkle_crypto")]
lib VerkleCrypto
  # fun create_context() : Void*
  fun hash(data : UInt8*, output : UInt8*)
end


module Pampero
  def self.hash(data : StaticArray(UInt8, 64)) : Bytes32
    # context = VerkleCrypto.create_context()
    output = uninitialized Bytes32
    VerkleCrypto.hash(data, output.@data.to_unsafe)
    output
  end
end
