# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

module Enumerable
  # 1. my_each
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < self.to_a.length do
      yield(self.to_a[i])
      i += 1
    end
    self
  end

  # 2. my_each_with_index
  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < self.to_a.length do
      yield(self.to_a[i], i)
      i += 1
    end
    self
  end

  # 3. my_select
  def my_select
    return to_enum unless block_given?

    new_array = []
    self.to_a.my_each { |element| new_array << element if yield(element) }
    new_array
  end

  # 4. my_all?
  def my_all?(arg = nil)
    if block_given?
      self.to_a.my_each { |x| return false unless yield(x) }
      return true
    elsif arg.nil?
      self.to_a.my_each { |x| return false unless x == true }
    elsif arg.is_a? Class
      self.to_a.my_each { |x| return false unless x.class }
    elsif arg.class == Regexp
      self.to_a.my_each { |x| return false unless arg.match(x) }
    else
      self.to_a.my_each { |x| return false unless x == arg }
    end
    true
  end

  # 5. my_any?
  def my_any?(arg = nil)
    if block_given?
      self.to_a.my_each { |x| return true if yield(x) }
      return false
    elsif arg.nil?
      self.to_a.my_each { |x| return true if x }
    elsif arg.is_a? Class
      self.to_a.my_each { |x| return true if x.class }
    elsif arg.class == Regexp
      self.to_a.my_each { |x| return true if arg.match(x) }
    else
      self.to_a.my_each { |x| return true if x == arg }
    end
    false
  end

  # 6. my_none?
  def my_none?(arg = nil)
    if block_given?
      !self.to_a.my_any?(&Proc.new)
    else
      !self.to_a.my_any?(arg)
    end
  end

  # 7. my_count?
  def my_count(arg = nil)
    count = 0
    if arg.nil?
      if block_given?
        self.to_a.my_each { |x| count += 1 if yield(x) }
      else
        count = self.to_a.length
      end
    else
      count = self.to_a.my_select { |x| x == arg }.length
    end
    count
  end

  # 8. my_map
  def my_map(proc = nil)
    return to_enum unless block_given? || !proc.nil

    new_array = []
    if proc
      to_a.my_each { |x| new_array << proc.call(x) }
    else
      to_a.my_each { |x| new_array << yield(x) }
    end
    new_array
  end

  # 9. my_inject

  # 10. multiply_els
end