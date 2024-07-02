require "spec"
require "json"
require "../src/core/verkle_state"
require "../src/models/verkle_execution_witness"
require "../src/models/block"

describe Pampero::VerkleState do
  it "executionWitness" do
    content = File.read(File.join(File.dirname(__FILE__), "data", "verkleKaustinen6Block72.json"))
    block = Pampero::Block.from_json(content)
    execution_witness = block.execution_witness

    state = Pampero::VerkleState.new
    state.init_execution_witness execution_witness
  end
end
