require_relative "static_array"

class DynamicArray < StaticArray
  attr_reader :length

  def initialize(capacity = 8)
    self.capacity = capacity
    self.length = 0
    super(capacity)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index < 0 || index >= length
    super
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" if index < 0 || index >= length
    super
  end

  # O(1)
  def pop
    temp = self[length - 1]
    self[length - 1] = "removed"
    self.length -= 1
    temp
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if !check_index(length)
    self.store[length] = val
    self.length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    temp = self[0]
    length.times do |idx|
      next if idx == length - 1
      self[idx] = self[idx + 1]
    end
    self[length - 1] = "removed"
    self.length -= 1
    temp
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if !check_index(length)
    if length == 0
      self.length += 1
      self[0] = val
      return
    end
    temp = self[0]
    length.times do |idx|
      next if idx == 0
      self[idx], temp = temp, self[idx]
    end
    store[length] = temp
    self[0] = val
    self.length += 1
    # binding.pry
    self
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    index < capacity
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    self.capacity = 1 if capacity < 1
    new_store = StaticArray.new(capacity * 2)
    capacity.times do |idx|
      new_store[idx] = store[idx]
    end
    self.store = new_store
    self.capacity = capacity * 2
    self.size = capacity
    self
  end
end
