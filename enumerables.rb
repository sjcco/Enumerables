# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

module Enumerable
  # 1. my_each
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < to_a.length
      yield(to_a[i])
      i += 1
    end
    self
  end

  # 2. my_each_with_index
  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < to_a.length
      yield(to_a[i], i)
      i += 1
    end
    self
  end

  # 3. my_select
  def my_select
    return to_enum unless block_given?

    new_array = []
    to_a.my_each { |element| new_array << element if yield(element) }
    new_array
  end

  # 4. my_all?
  def my_all?(arg = nil)
    if block_given?
      to_a.my_each { |x| return false unless yield(x) }
      return true
    elsif arg.nil?
      to_a.my_each { |x| return false unless x == true }
    elsif arg.is_a? Class
      to_a.my_each { |x| return false unless x.class }
    elsif arg.instance_of?(Regexp)
      to_a.my_each { |x| return false unless arg.match(x) }
    else
      to_a.my_each { |x| return false unless x == arg }
    end
    true
  end

  # 5. my_any?
  def my_any?(arg = nil)
    if block_given?
      to_a.my_each { |x| return true if yield(x) }
      return false
    elsif arg.nil?
      to_a.my_each { |x| return true if x }
    elsif arg.is_a? Class
      to_a.my_each { |x| return true if x.class }
    elsif arg.instance_of?(Regexp)
      to_a.my_each { |x| return true if arg.match(x) }
    else
      to_a.my_each { |x| return true if x == arg }
    end
    false
  end

  # 6. my_none?
  def my_none?(arg = nil)
    if block_given?
      !to_a.my_any?(&Proc.new)
    else
      !to_a.my_any?(arg)
    end
  end

  # 7. my_count?
  def my_count(arg = nil)
    count = 0
    if arg.nil?
      if block_given?
        to_a.my_each { |x| count += 1 if yield(x) }
      else
        count = to_a.length
      end
    else
      count = to_a.my_select { |x| x == arg }.length
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
  def my_inject(arg1 = nil, arg2 = nil)
    return raise LocalJumpError, 'Expecting a block or any argument' if !block_given? && arg1.nil? && arg2.nil?

    if !block_given?
      if arg2.nil?
        arg2 = arg1
        arg1 = nil
      end
      arg2.to_sym
      my_each { |x| arg1 = arg1.nil? ? x : arg1.send(arg2, x) }
    else
      my_each { |x| arg1 = arg1.nil? ? x : yield(arg1, x) }
    end
    arg1
  end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

# 10. multiply_els
def multiply_els(array)
  array.my_inject(:*)
end
