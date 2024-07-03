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
end
