class StringHelper

  # Returns if *s* starts with `0x`
  def self.hex?(s : String) : Bool
    s.size > 2 && s[0] == '0' && s[1].downcase == 'x'
  end

  # Returns the string without the `0x` prefix, if it has it, or the string itself otherwise.
  def self.hexstring(s : String) : String
    if self.hex?(s)
      s[2..]
    else
      s
    end
  end
end
