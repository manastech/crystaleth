module Pampero
  alias Address20 = StaticArray(UInt8, 20)
  alias Address32 = StaticArray(UInt8, 32)
  alias Bytes32 = StaticArray(UInt8, 32)
  alias Bytes64 = StaticArray(UInt8, 64)

  def self.to_bytes32(val : UInt64) : Bytes32
    result = Bytes32.new(0u8)
    i = 31
    while val > 0 && i >= 0
      result[i] = (val & 0xFF).to_u8
      val = val >> 8
    end
    result
  end
end
