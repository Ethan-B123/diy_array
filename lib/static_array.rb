# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(length=0)
    self.size = length
    self.store = Array.new(length)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index < 0 || index >= size
    store[index]
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" if index < 0 || index >= size
    self.store[index] = value
  end

  protected
  attr_accessor :store, :size
end
