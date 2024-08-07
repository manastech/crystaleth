require "http/client"
require "kemal"
require "./config"
require "./models/block"
require "./core/verkle_state_manager"

module Pampero
  VERSION = "0.1.0"
end


get "/" do
  response = HTTP::Client.get "#{Pampero::BEACON_NODE}/eth/v2/beacon/blocks/head"
  # if response.status_code != 200
  #   error = JSON.parse response.body
  #   # error = h["message"]
  #   render "src/views/block.ecr", "src/views/layouts/layout.ecr"
  #   return
  # end

  content = response.body
  block = Pampero::Block.from_json content

  payload = block.data.message.body.execution_payload
  execution_witness = payload.execution_witness

  verkle = Pampero::VerkleStateManager.new
  verkle.init_execution_witness execution_witness

  render "src/views/block.ecr", "src/views/layouts/layout.ecr"
end

Kemal.run
