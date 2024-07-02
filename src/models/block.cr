require "json"
require "./verkle_execution_witness"

module Pampero
  struct Block
    include JSON::Serializable
    # property header : String
    # property transactions : Array(String)
    # property withdrawals : Array(String)
    @[JSON::Field(key: "executionWitness")]
    property execution_witness : VerkleExecutionWitness
  end
end
