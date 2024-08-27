class String
  def hex? : Bool
    self.size > 2 && self[0] == '0' && self[1].downcase == 'x'
  end

  def hexstring : String
    if self.hex?
      self[2..]
    else
      self
    end
  end
end
