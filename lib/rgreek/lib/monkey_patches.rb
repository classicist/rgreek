String.class_eval do
  def to_unicode_points
    self.split("").map{ |char| "%4.4x" % char.unpack("U") }
  end
end
