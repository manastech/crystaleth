require "spec"
require "../src/core/verkle_crypto"
require "../src/common/types"

describe Pampero::Crypto do
  zero = Pampero::Bytes64.new 0_u8

  it "hash" do
    expected = Pampero::Bytes32.new "0x1a100684fd68185060405f3f160e4bb6e034194336b547bdae323f888d533207"

    result = Pampero::Crypto.hash zero

    result.should eq(expected)
  end

  it "keccack" do
    input = Slice(UInt8).new(0)
    expected = Pampero::Bytes32.new "0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"

    result = Pampero::Crypto.keccak256 input
    result.should eq(expected)
  end
end
