require "dotenv"
require "http/client"
require "kemal"
require "./config"
require "./models/block"
require "./core/verkle_state_manager"

module Pampero
  VERSION = "0.1.0"
end

Dotenv.load

config = Pampero::Config.new

get "/block/:slot" do |env|
  slot = env.params.url["slot"]
  if slot == "latest"
    slot = "head"
  end
  response = HTTP::Client.get "#{config.beacon_node}/eth/v2/beacon/blocks/#{slot}"
  if response.status_code != 200
    error = JSON.parse response.body
    render "src/views/block-error.ecr", "src/views/layouts/layout.ecr"
  else
    content = response.body
    block = Pampero::Block.from_json content

    payload = block.data.message.body.execution_payload
    execution_witness = payload.execution_witness

    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness

    render "src/views/block.ecr", "src/views/layouts/layout.ecr"
  end
end

get "/block/:slot/account/:address" do |env|
  slot = env.params.url["slot"]
  if slot == "latest"
    slot = "head"
  end
  response = HTTP::Client.get "#{config.beacon_node}/eth/v2/beacon/blocks/#{slot}"
  if response.status_code != 200
    error = JSON.parse response.body

    error.to_json
  else
    content = response.body
    block = Pampero::Block.from_json content

    payload = block.data.message.body.execution_payload
    execution_witness = payload.execution_witness

    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness

    address = Pampero::Address20.new env.params.url["address"]
    account = verkle.get_account(address) || {} of String => String

    account.to_json
  end
end

Kemal.run
