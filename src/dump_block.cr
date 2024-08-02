require "http/client"
require "./models/block"
require "./core/verkle_state_manager"

module Pampero
  BEACON_NODE = "https://beacon.verkle-gen-devnet-6.ethpandaops.io"

  def self.print_block(block : Pampero::Block)
    payload = block.data.message.body.execution_payload
    execution_witness = payload.execution_witness

    print "Slot: #{block.data.message.slot}\n"
    print "Block: #{payload.block_number}\n"
    print "Hash: #{payload.block_hash}\n"
    print "Date: #{Time.unix(payload.timestamp.to_i)}\n"

    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness

    verkle.@state.@state.each do |key, value|
      print "  Key: #{key.to_s}\n"
      print "  Value: #{value.to_s}\n"
    end
  end

  # Accepts a slot number as input parameter
  # Default to 'head' if it isn't specified
  def self.dump_block
    slot = "head"
    unless ARGV.empty?
      slot = ARGV.first
    end

    response = HTTP::Client.get "#{BEACON_NODE}/eth/v2/beacon/blocks/#{slot}"
    if response.status_code != 200
      h = JSON.parse response.body
      print "Failed to get slot: #{slot}\n  #{h["message"]}"
      return
    end

    content = response.body
    block = Pampero::Block.from_json content
    print_block block
  end
end

Pampero.dump_block
