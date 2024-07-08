require "spec"
require "json"
require "../src/core/verkle_state"
require "../src/models/verkle_execution_witness"
require "../src/models/block"

describe Pampero::VerkleState do
  content = File.read(File.join(File.dirname(__FILE__), "data", "verkleKaustinen6Block72.json"))
  block = Pampero::Block.from_json(content)
  execution_witness = block.execution_witness

  key = Pampero::Bytes32.new "df67dea9181141d6255ac05c7ada5a590fb30a375023f16c31223f067319e303"
  value = Pampero::Bytes32.new "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"

  key_empty = Pampero::Bytes32.new "3e304e4b99e7b80d5d2b337044c06d72a43decdaf6821d683cadc151f450c633"

  it "initializtion" do
    state = Pampero::VerkleState.new

    result = state.read_key key
    result.should be_nil
  end

  it "execution_witness" do
    state = Pampero::VerkleState.new
    state.init_execution_witness execution_witness

    result = state.read_key key
    result.should eq(value)
  end

  it "read_key" do
    state = Pampero::VerkleState.new
    state.init_execution_witness execution_witness

    result = state.read_key key_empty
    result.should be_nil

    result = state.read_key key
    result.should eq(value)
  end

  it "write_key" do
    state = Pampero::VerkleState.new

    state.write_key key, value
    result = state.read_key key
    result.should eq(value)

    state.write_key key, nil
    result = state.read_key key
    result.should be_nil
  end
end
