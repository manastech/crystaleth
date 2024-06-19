module Pampero
  alias Address20 = StaticArray(UInt8, 20)
  alias Address32 = StaticArray(UInt8, 32)
  alias Bytes32 = StaticArray(UInt8, 32)
  alias Bytes64 = StaticArray(UInt8, 64)
  alias UInt256 = StaticArray(UInt128, 2)

  def self.to_bytes32(val : UInt64) : Bytes32
    result = Bytes32.new(0u8)
    i = 31
    while val > 0 && i >= 0
      result[i] = (val & 0xFF).to_u8
      val = val >> 8
    end
    result
  end

  def self.to_uint256(val : Bytes32) : UInt256
    result = UInt256.new(0u128)
    16.times do |i|
      result[0] = result[0] * 256u128 + val[i]
      result[1] = result[1] * 256u128 + val[16 + i]
    end
    result
  end
end
