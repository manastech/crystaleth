require "spec"
require "../src/core/verkle_state_manager"
require "../src/common/types"

describe Pampero::VerkleStateManager do
  address = Pampero::Address20.new 0_u8

  it "init" do
    v = Pampero::VerkleStateManager.new
    v.should_not eq(nil)
  end

  it "get_account" do
    v = Pampero::VerkleStateManager.new
    a = v.get_account address
    a.should_not eq(nil)
    a.version.should eq(Pampero::UInt256.new(0_u8))
  end
end
