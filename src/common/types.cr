require "big"

require "./string_helper"

module Pampero
  alias Address32 = StaticArray(UInt8, 32)
  # Integers are little endian
  alias UInt256 = BigInt

  struct Address20
    @data : StaticArray(UInt8, 20)

    def initialize(val : UInt8 = 0_u8)
      @data = StaticArray(UInt8, 20).new val
    end

    def initialize(str : String)
      @data = uninitialized StaticArray(UInt8, 20)
      str = StringHelper.hexstring str
      raise "Invalid format: string has #{str.size} size, but must be 40" if str.size != 40

      20.times do |i|
        @data[i] = str[2*i..2*i + 1].to_u8(16)
      end
    end
  end

  struct Bytes32
    @data : StaticArray(UInt8, 32)

    def initialize(val : UInt8 = 0_u8)
      @data = StaticArray(UInt8, 32).new val
    end

    def initialize(data : StaticArray(UInt8, 32))
      @data = data.clone
    end

    def initialize(val : BigInt | UInt64)
      @data = uninitialized StaticArray(UInt8, 32)
      i = 31
      while i >= 0
        @data[31 - i] = (val & 0xFF).to_u8
        val = val >> 8
        i -= 1
      end
    end

    def initialize(str : String)
      @data = uninitialized StaticArray(UInt8, 32)
      str = StringHelper.hexstring str
      raise "Invalid format: string has #{str.size} size, but must be 64" if str.size != 64

      32.times do |i|
        @data[i] = str[2*i..2*i + 1].to_u8(16)
      end
    end

    def to_uint256 : UInt256
      result = BigInt.new 0
      32.times do |i|
        result = result * 256 + @data[31 - i]
      end
      result
    end

    def to_hex : String
      str = String.build do |str|
        str << "0x"
        32.times do |i|
          str << sprintf("%02x", @data[i])
        end
      end
      str
    end

    def to_s : String
      to_hex
    end

    def inspect : String
      to_hex
    end

    def to_json(json : JSON::Builder) : Nil
      json.string(to_hex)
    end

    def to_json_object_key : String
      to_hex
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
