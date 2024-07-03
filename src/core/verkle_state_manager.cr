require "../models/account"
require "../models/verkle_execution_witness"
require "../common/address"
require "../common/types"
require "../core/verkle_crypto"
require "../core/verkle_state"

module Pampero
  LEAF_VERSION   = 0u8
  LEAF_BALANCE   = 1u8
  LEAF_NONCE     = 2u8
  LEAF_CODE_HASH = 3u8
  LEAF_CODE_SIZE = 4u8

  class VerkleStateManager
    def initialize
      @state = VerkleState.new
    end

    def init_execution_witness(execution_witness : VerkleExecutionWitness)
      @state.init_execution_witness execution_witness
    end

    def get_account(address : Address20)
      stem = get_stem address, 0_u64

      read_account(stem)
    end

    def get_stem(address : Address20, treeIndex : UInt64) : Bytes32
      address32 = Address32.new 0_u8

      20.times do |i|
        address32[12 + i] = address.@data[i]
      end

      index = Bytes32.new treeIndex

      get_tree_key address32, index
    end

    def read_account(stem : Bytes32)
      account = Account.new
      account.version = read_version stem
      account.balance = read_balance stem
      account.nonce = read_nonce stem
      account.code_hash = read_code_hash stem
      account.code_size = read_code_size stem
      account
    end

    def get_tree_key(address : Address32, treeIndex : Bytes32) : Bytes32
      data = Bytes64.new address, treeIndex.@data
      Pampero::Crypto.hash data
    end

    def read_version(stem : Bytes32) : UInt256
      key = get_key stem, LEAF_VERSION
      read_key(key).to_uint256
    end

    def read_balance(stem : Bytes32) : UInt256
      key = get_key stem, LEAF_BALANCE
      read_key(key).to_uint256
    end

    def read_nonce(stem : Bytes32) : UInt256
      key = get_key stem, LEAF_NONCE
      read_key(key).to_uint256
    end

    def read_code_hash(stem : Bytes32) : Bytes32
      key = get_key stem, LEAF_CODE_HASH
      read_key(key)
    end

    def read_code_size(stem : Bytes32) : UInt256
      key = get_key stem, LEAF_CODE_SIZE
      read_key(key).to_uint256
    end

    def get_key(stem : Bytes32, leaf : UInt8) : Bytes32
      data = Bytes32.new stem.@data
      data.@data[31] = leaf
      data
    end

    def read_key(key : Bytes32) : Bytes32
      @state.read_key key
    end
  end
end
