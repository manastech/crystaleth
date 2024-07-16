require "./types"

module Pampero
  # keccak256 of an empty byte array
  KECCAK256_NULL_S = "0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
  KECCAK256_NULL = Pampero::Bytes32.new KECCAK256_NULL_S
end
