require "spec"
require "../src/core/verkle_state_manager"
require "../src/common/types"
require "../src/models/verkle_execution_witness"
require "../src/models/block"

describe Pampero::VerkleStateManager do
  content = File.read(File.join(File.dirname(__FILE__), "data", "verkleKaustinen6Block72.json"))
  block = Pampero::Block.from_json(content)
  execution_witness = block.execution_witness

  address = Pampero::Address20.new "0x6177843db3138ae69679a54b95cf345ed759450d"

  address_empty = Pampero::Address20.new "0xa3ffb7daee76edf3aa497ec8c2f0aa7251b302b7"

  it "get_account" do
    verkle = Pampero::VerkleStateManager.new

    account = verkle.get_account address

    account.should be_nil
  end

  it "get_account with witness" do
    verkle = Pampero::VerkleStateManager.new
    verkle.init_execution_witness execution_witness

    account = verkle.get_account address

    account.should_not be_nil
    if account
      account.balance.should eq(288610978528114322)
      account.nonce.should eq(300)
    end
  end

  it "put_account" do
    verkle = Pampero::VerkleStateManager.new

    account = verkle.get_account address_empty
    account.should be_nil

    account = Pampero::Account.new(nonce: BigInt.new(2))

    verkle.put_account address_empty, account

    result = verkle.get_account address_empty

    result.should eq(account)
  end

  it "delete_account" do
    verkle = Pampero::VerkleStateManager.new

    account = Pampero::Account.new(nonce: BigInt.new(2))

    verkle.put_account address_empty, account

    result = verkle.get_account address_empty
    result.should_not be_nil

    verkle.delete_account address_empty

    result = verkle.get_account address_empty
    result.should be_nil
  end

  it "put_contract_code" do
    keccack256_null = Pampero::Bytes32.new "0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
    bytecode = Slice(UInt8).new(0)
    verkle = Pampero::VerkleStateManager.new

    verkle.put_contract_code address_empty, bytecode

    account = verkle.get_account address_empty

    account.should_not be_nil
    if account
      account.code_hash.should eq(keccack256_null)
    end
  end

  it "get_contract_code" do
    verkle = Pampero::VerkleStateManager.new

    result = verkle.get_contract_code address_empty
    
    result.should be_empty
  end

  it "get_stem" do
    expected = "0x1540dfad7755b40be0768c6aa0a5096fbf0215e0e8cf354dd928a17834646600"
    address = Pampero::Address20.new "0x71562b71999873DB5b286dF957af199Ec94617f7"
    verkle = Pampero::VerkleStateManager.new

    stem = verkle.get_stem address, 0_u64

    stem.to_s.should eq(expected)
  end
end
