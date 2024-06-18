require "../models/account"
require "../common/address"
require "../common/types"
require "../core/verkle_crypto"

class Pampero::VerkleState
  def getAccount(address : Address20)
    stem = getStem(address, 0u64)

    readAccount(stem)
  end

  def getStem(address : Address20, treeIndex : UInt64) : Bytes32
    address32 = Address32.new(0u8)

    20.times do |i|
      address32[12 + i] = address[i]
    end

    index = Pampero.to_bytes32(treeIndex)

    getTreeKey(address32, index)
  end

  def readAccount(stem : Bytes32)
    account = Account.new()
    account.version = readVersion(stem)
    account.balance = readBalance(steam)
    account.nonce = readNonce(stem)
    account.codeHash = readCodeHash(stem)
    account.codeSize = readCodeSize(stem)
    account.storageRoot = readStorageRoot(stem)
    account
  end

  def getTreeKey(address : Address32, treeIndex : Bytes32)
    data = Array(UInt8).new(64, 0u8)
    32.times do |i|
      data[i] = address[i]
      data[32 + i] = treeIndex[i]
    end
    Pampero::VerkleCrypto.hash(data)
  end

  def readVersion(stem : Bytes32)
    key = getKey(stem, LEAF_VERSION)
    readKey(key)
  end

  def readBalance(stem : Bytes32)
    key = getKey(stem, LEAF_BALANCE)
    readKey(key)
  end

  def getKey(steam : Bytes32, leaf : Bytes32)
    steam.concat(leaf)
  end

end

