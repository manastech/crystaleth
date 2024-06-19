require "../models/account"
require "../common/address"
require "../common/types"
require "../core/verkle_crypto"
require "../core/verkle_state"

module Pampero
  LEAF_VERSION      = 0u8
  LEAF_BALANCE      = 1u8
  LEAF_NONCE        = 2u8
  LEAF_CODE_HASH    = 3u8
  LEAF_CODE_SIZE    = 4u8
  LEAF_STORAGE_ROOT = 5u8

  class VerkleStateManager
    def initialize
      @state = VerkleState.new
    end

    def get_account(address : Address20)
      stem = get_stem(address, 0u64)

      read_account(stem)
    end

    def get_stem(address : Address20, treeIndex : UInt64) : Bytes32
      address32 = Address32.new(0u8)

      20.times do |i|
        address32[12 + i] = address[i]
      end

      index = Pampero.to_bytes32(treeIndex)

      get_tree_key(address32, index)
    end

    def read_account(stem : Bytes32)
      account = Account.new
      account.version = read_version(stem)
      account.balance = read_balance(stem)
      account.nonce = read_nonce(stem)
      account.code_hash = read_code_hash(stem)
      account.code_size = read_code_size(stem)
      account.storage_root = read_storage_root(stem)
      account
    end

    def get_tree_key(address : Address32, treeIndex : Bytes32) : Bytes32
      data = Array(UInt8).new(64, 0u8)
      32.times do |i|
        data[i] = address[i]
        data[32 + i] = treeIndex[i]
      end
      VerkleCrypto.hash(data)
    end

    def read_version(stem : Bytes32) : UInt256
      key = get_key(stem, LEAF_VERSION)
      Pampero.to_uint256(read_key(key))
    end

    def read_balance(stem : Bytes32) : UInt256
      key = get_key(stem, LEAF_BALANCE)
      Pampero.to_uint256(read_key(key))
    end

    def read_nonce(stem : Bytes32) : UInt256
      key = get_key(stem, LEAF_NONCE)
      Pampero.to_uint256(read_key(key))
    end

    def read_code_hash(stem : Bytes32) : Bytes32
      key = get_key(stem, LEAF_CODE_HASH)
      read_key(key)
    end

    def read_code_size(stem : Bytes32) : UInt256
      key = get_key(stem, LEAF_CODE_SIZE)
      Pampero.to_uint256(read_key(key))
    end

    def read_storage_root(stem : Bytes32) : Bytes32
      key = get_key(stem, LEAF_STORAGE_ROOT)
      read_key(key)
    end

    def get_key(stem : Bytes32, leaf : UInt8) : Bytes32
      data = stem.clone
      data[31] = leaf
      data
    end

    def read_key(key : Bytes32) : Bytes32
      @state.read_key(key)
    end
  end
end
