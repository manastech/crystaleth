require "./core/verkle_crypto"

module Pampero
  VERSION = "0.1.0"

  a = VerkleCrypto.hash("hi")
  puts a
end
