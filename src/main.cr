require "./core/verkle_crypto"

module Pampero
  VERSION = "0.1.0"

  # c = VerkleCrypto.create_context()
  input = Bytes64.new(0u8)
  output = Bytes32.new(0u8)
  VerkleCrypto.hash(input, output.@data.to_unsafe)
  32.times do |i|
    printf "%02x", output.@data[i]
  end
end
