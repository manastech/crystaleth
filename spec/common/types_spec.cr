require "spec"
require "big"
require "../../src/common/types"

describe Pampero::Bytes32 do
  data = "0x1a100684fd68185060405f3f160e4bb6e034194336b547bdae323f888d533207"
  it "new" do
    bytes = Pampero::Bytes32.new data
    32.times do |i|
      byte = data[2+2*i..2+2*i+1].to_u8(16)
      bytes.@data[i].should eq(byte)
    end
  end

  it "to_s" do
    expected = data
    bytes = Pampero::Bytes32.new data
    result = bytes.to_s
    result.should eq(expected)
  end

  it "to_uint256" do
    expected = BigInt.new "52435875175126190479447740508185965837690552500527637822603658699938581184513"
    bytes = Pampero::Bytes32.new BigInt.new("52435875175126190479447740508185965837690552500527637822603658699938581184513")
    result = bytes.to_uint256
    result.should eq(expected)
  end
end
