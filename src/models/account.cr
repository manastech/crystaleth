struct Account
  property version : UInt64 
  property balance : UInt64
  property nonce : UInt64
  property codeHash : String
  property codeSize : String
  property storageRoot : String

  def initialize
    @version = 0
    @balance = 0
    @nonce = 0
    @codeHash = ""
    @codeSize = ""
    @storageRoot = ""
  end
end
