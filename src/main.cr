require "./core/verkle_crypto"

module Pampero
  VERSION = "0.1.0"

  c = VerkleCrypto.create_context()
  input = Bytes64.new(0u8)
  output = Bytes32.new(0u8)
  VerkleCrypto.hash(c, input, output)
  puts output[0]
end
