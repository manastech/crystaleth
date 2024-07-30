require "json"
require "./verkle_execution_witness"

module Pampero
  struct Block
    include JSON::Serializable
    property data : Data
  end

  struct Data
    include JSON::Serializable
    property message : Message
  end

  struct Message
    include JSON::Serializable
    property body : Body
  end

  struct Body
    include JSON::Serializable
    property execution_payload : ExecutionPayload
  end

  struct ExecutionPayload
    include JSON::Serializable
    property parent_hash : String
    property state_root : String
    property block_number : String
    property timestamp : String
    property block_hash : String
    # property transactions : Array(String)
    # property withdrawals : Array(String)
    property execution_witness : VerkleExecutionWitness
  end
end
