require "sha3"
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

    def self.keccak256(input : Bytes) : Bytes32
      digest = Digest::Keccak3.new(256)
      digest.update input
      Bytes32.new digest.hexdigest
    end
  end
end
