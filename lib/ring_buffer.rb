require_relative "static_array"
require "pry"
require "byebug"

class RingBuffer < StaticArray
  attr_reader :length

  def initialize(capacity = 8)
    self.capacity = capacity
    self.length = 0
    self.start_idx = 0
    super(capacity)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index < 0 || index >= length
    super((index + start_idx) % capacity)
  end

  # O(1)
  def []=(index, val)
    raise "index out of bounds" if index < 0 || index >= length
    super((index + start_idx) % capacity, val)
  end

  # O(1)
  def pop
    temp = self[length - 1]
    self[length - 1] = "removed"
    self.length -= 1
    temp
  end

  # O(1) ammortized
  def push(val)
    resize! if !check_index(length)
    self.length += 1
    self[length - 1] = val
  end

  # O(1)
  def shift
    temp = self[0]
    self[0] = "shifted"
    self.start_idx = (start_idx + 1) % capacity
    self.length -= 1
    temp
  end

  # O(1) ammortized
  def unshift(val)
    resize! if !check_index(length)
    self.start_idx = (start_idx - 1) % capacity
    self.length += 1
    self[0] = val
    self
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    index < capacity
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    self.capacity = 1 if capacity < 1
    new_store = StaticArray.new(capacity * 2)
    capacity.times do |idx|
      new_store[idx] = self[idx]
    end
    self.start_idx = 0
    self.store = new_store
    self.capacity = capacity * 2
    self.size = capacity
    self
  end
end
