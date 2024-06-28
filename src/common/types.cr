module Pampero
  alias Address20 = StaticArray(UInt8, 20)
  alias Address32 = StaticArray(UInt8, 32)
  alias UInt256 = StaticArray(UInt128, 2)

  # struct Address20
  #   @data = StaticArray(UInt8, 20)
  # end

  # struct Address32
  #   @data = StaticArray(UInt8, 32)
  # end

  struct Bytes32
    @data : StaticArray(UInt8, 32)

    def initialize(val : UInt8 = 0_u8)
      @data = StaticArray(UInt8, 32).new val
    end

    def initialize(data : StaticArray(UInt8, 32))
      @data = data.clone
    end

    def initialize(val : UInt64)
      @data = uninitialized StaticArray(UInt8, 32)
      i = 31
      while i >= 0
        @data[i] = (val & 0xFF).to_u8
        val = val >> 8
        i -= 1
      end
    end

    def initialize(str : String)
      @data = uninitialized StaticArray(UInt8, 32)
      str = str[2..] if str[0] == '0' && (str[1] == 'x' || str[1] == 'X')
      if str.size != 64
        raise "Invalid format"
      end
      32.times do |i|
        @data[i] = str[2*i..2*i+1].to_u8(16)
      end
    end

    def to_uint256 : UInt256
      result = UInt256.new 0_u128
      16.times do |i|
        result[0] = result[0] * 256_u128 + @data[i]
        result[1] = result[1] * 256_u128 + @data[16 + i]
      end
      result
    end
  end

  struct Bytes64
    @data : StaticArray(UInt8, 64)

    def initialize(val : UInt8 = 0_u8)
      @data = StaticArray(UInt8, 64).new val
    end

    def initialize(a : StaticArray(UInt8, 32), b : StaticArray(UInt8, 32))
      @data = uninitialized StaticArray(UInt8, 64)
      32.times do |i|
        @data[i] = a[i]
        @data[32 + i] = b[i]
      end
    end
  end
end
