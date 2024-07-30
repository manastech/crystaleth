require "http/client"
require "./models/block"
require "./core/verkle_state_manager"

module Pampero
  BEACON_NODE = "https://beacon.verkle-gen-devnet-6.ethpandaops.io"

  def self.print_block(block : Pampero::Block)
    payload = block.data.message.body.execution_payload;
    execution_witness = payload.execution_witness

    print "Block: ", payload.block_number, "\n"
    print "Hash: ", payload.block_hash, "\n"
    print "Date: ", Time.unix(payload.timestamp.to_i), "\n"

    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness
  end

  def self.dump_block
    response = HTTP::Client.get "#{BEACON_NODE}/eth/v2/beacon/blocks/head"

    block = Pampero::Block.from_json response.body

    payload = block.data.message.body.execution_payload;
    execution_witness = payload.execution_witness

    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness

    print_block block
  end
end

Pampero.dump_block
