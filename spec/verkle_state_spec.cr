require "spec"
require "../src/core/verkle_state"

address = Pampero::Address20.new(0)

describe Pampero::VerkleState do
  it "init" do
    v = Pampero::VerkleState.new
    v.should_not eq(nil)
  end

  it "getAccount" do
    v = Pampero::VerkleState.new
    a = v.getAccount(address)
    a.should_not eq(nil)
    a.version.should eq(0)
  end
end
