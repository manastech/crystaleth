require "../models/account"
require "../models/verkle_execution_witness"
require "../common/address"
require "../common/types"
require "../core/verkle_crypto"
require "../core/verkle_state"

module Pampero
  LEAF_VERSION   = 0_u8
  LEAF_BALANCE   = 1_u8
  LEAF_NONCE     = 2_u8
  LEAF_CODE_HASH = 3_u8
  LEAF_CODE_SIZE = 4_u8

  CODE_OFFSET       = BigInt.new(128)
  VERKLE_NODE_WIDTH = BigInt.new(256)

  HEADER_STORAGE_OFFSET = BigInt.new(64)
  MAIN_STORAGE_OFFSET   = VERKLE_NODE_WIDTH ^ 31

  CHUNK_LENGTH = BigInt.new(31)

  class VerkleStateManager
    def initialize
      @state = VerkleState.new
    end

    def init_execution_witness(execution_witness : VerkleExecutionWitness)
      @state.init_execution_witness execution_witness
    end

    def get_account(address : Address20) : Account?
      stem = get_stem(address, UInt256.new(0))

      version = read_version(stem)
      balance = read_balance(stem)
      nonce = read_nonce(stem)
      code_hash = read_code_hash(stem)
      code_size = read_code_size(stem)

      # If at least one of the fields is not nil we assume the account exists
      return nil if version.nil? && balance.nil? && nonce.nil? && code_hash.nil? && code_size.nil?

      account = Account.new
      account.version = version
      account.balance = balance
      account.nonce = nonce
      account.code_hash = code_hash
      account.code_size = code_size

      account
    end

    def put_account(address : Address20, account : Account)
      stem = get_stem(address, UInt256.new(0))

      write_version stem, account.version
      write_balance stem, account.balance
      write_nonce stem, account.nonce
      write_code_hash stem, account.code_hash
      write_code_size stem, account.code_size
    end

    def delete_account(address : Address20)
      stem = get_stem(address, UInt256.new(0))

      write_version stem, nil
      write_balance stem, nil
      write_nonce stem, nil
      write_code_hash stem, nil
      write_code_size stem, nil
    end

    def put_contract_code(address : Address20, value : Bytes)
      code_hash = Pampero::Crypto.keccak256(value)

      unless account = get_account(address)
        account = Account.new
      end
      account.code_hash = code_hash
      put_account address, account
    end

    def get_contract_code(address : Address20) : Bytes
      unless (account = get_account(address)) && (code_size = account.code_size)
        return Slice(UInt8).new 0
      end

      code_size = code_size.to_u64
      chunks = (code_size + CHUNK_LENGTH - 1).tdiv(CHUNK_LENGTH)

      bytecode = Slice(UInt8).new(code_size + CHUNK_LENGTH)

      chunks.times do |i|
        chunk = read_code_chunk(address, UInt256.new(i))
        (bytecode + i * CHUNK_LENGTH).copy_from chunk.@data.to_slice
      end

      bytecode[0...code_size]
    end

    def put_contract_storage(address : Address20, key : Bytes32, value : Bytes32)
      storage_key = get_tree_storage_key(address, key.to_uint256)
      write_bytes32(storage_key, value)
    end

    def get_contract_storage(address : Address20, key : Bytes32) : Bytes32?
      storage_key = get_tree_storage_key(address, key.to_uint256)
      read_bytes32(storage_key)
    end

    def clear_contract_storage(address : Address20, key : Bytes32)
      storage_key = get_tree_storage_key(address, key.to_uint256)
      write_bytes32(storage_key, KECCAK256_NULL)
    end

    # The stem are first 31 bytes
    def get_stem(address : Address20, treeIndex : UInt256) : Bytes32
      address32 = Address32.new 0_u8

      20.times do |i|
        address32[12 + i] = address.@data[i]
      end

      index = Bytes32.new treeIndex

      get_tree_key address32, index, 0_u8
    end

    def get_tree_key(address : Address32, treeIndex : Bytes32, subIndex : UInt8) : Bytes32
      data = Bytes64.new address, treeIndex.@data
      key = Pampero::Crypto.hash data
      key.@data[31] = subIndex
      key
    end

    def get_tree_storage_key(address : Address20, storage_key : UInt256) : Bytes32
      position = if storage_key < CODE_OFFSET - HEADER_STORAGE_OFFSET
                   HEADER_STORAGE_OFFSET + storage_key
                 else
                   MAIN_STORAGE_OFFSET + storage_key
                 end

      calc_tree_key(address, position)
    end

    def get_key(stem : Bytes32, leaf : UInt8) : Bytes32
      key = Bytes32.new stem.@data
      key.@data[31] = leaf
      key
    end

    def read_version(stem : Bytes32) : UInt256?
      key = get_key stem, LEAF_VERSION
      read_uint256(key)
    end

    def read_balance(stem : Bytes32) : UInt256?
      key = get_key stem, LEAF_BALANCE
      read_uint256(key)
    end

    def read_nonce(stem : Bytes32) : UInt256?
      key = get_key stem, LEAF_NONCE
      read_uint256(key)
    end

    def read_code_hash(stem : Bytes32) : Bytes32?
      key = get_key stem, LEAF_CODE_HASH
      read_bytes32(key)
    end

    def read_code_size(stem : Bytes32) : UInt256?
      key = get_key stem, LEAF_CODE_SIZE
      read_uint256(key)
    end

    def read_code_chunk(address : Address20, chunk_index : UInt256) : Bytes32
      chunk_key = calc_tree_key(address, CODE_OFFSET + chunk_index)
      unless chunk = read_bytes32(chunk_key)
        # Fill chunk with INVALID opcodes
        chunk = Bytes32.new 0xfe_u8
      end
      chunk
    end

    def calc_tree_key(address : Address20, offset : UInt256) : Bytes32
      tree_index, sub_index = offset.divmod(VERKLE_NODE_WIDTH)
      stem = get_stem(address, UInt256.new(tree_index))
      get_key(stem, sub_index.to_u8)
    end

    def write_version(stem : Bytes32, version : UInt256?)
      key = get_key stem, LEAF_VERSION
      write_uint256 key, version
    end

    def write_balance(stem : Bytes32, balance : UInt256?)
      key = get_key stem, LEAF_BALANCE
      write_uint256 key, balance
    end

    def write_nonce(stem : Bytes32, nonce : UInt256?)
      key = get_key stem, LEAF_NONCE
      write_uint256 key, nonce
    end

    def write_code_hash(stem : Bytes32, code_hash : Bytes32?)
      key = get_key stem, LEAF_CODE_HASH
      write_bytes32 key, code_hash
    end

    def write_code_size(stem : Bytes32, code_size : UInt256?)
      key = get_key stem, LEAF_CODE_SIZE
      write_uint256 key, code_size
    end

    def read_key(key : Bytes32) : Bytes32?
      @state.read_key key
    end

    def read_bytes32(key : Bytes32) : Bytes32?
      read_key(key)
    end

    def read_uint256(key : Bytes32) : UInt256?
      if result = read_key(key)
        result = result.to_uint256
      end
      result
    end

    def write_key(key : Bytes32, data : Bytes32?)
      @state.write_key key, data
    end

    def write_bytes32(key : Bytes32, data : Bytes32?)
      write_key key, data
    end

    def write_uint256(key : Bytes32, value : UInt256?)
      data = Bytes32.new(value) unless value.nil?
      write_key key, data
    end
  end
end
