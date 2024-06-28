require "../common/types"

@[Link("verkle_crypto")]
lib VerkleCrypto
  fun hash(data : UInt8*, output : UInt8*)
end


module Pampero
  module Crypto
    def self.hash(input : Bytes64) : Bytes32
      output = uninitialized Bytes32
      VerkleCrypto.hash input.@data.to_unsafe, output.@data.to_unsafe
      output
    end
  end
end
