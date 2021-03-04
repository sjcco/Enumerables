require './enumerables'

describe '#my_each' do
  let(:array) { [1, 2, 3] }
  context 'No block is given' do
    it 'returns an enumerator' do
      expect(array.my_each).to be_an(Enumerator)
    end
  end
  context 'A block is given' do
    let(:my_test) { [] }
    let(:test) { [] }

    it 'calls the block for each element' do
      array.my_each { |item| my_test << (item + 1) }
      array.each { |item| test << (item + 1) }
      expect(my_test).to eql(test)
    end

    it 'It does not modify original array' do
      other_array = array
      array.my_each { |item| item + 1 }
      expect(array).to eql(other_array)
    end
  end
end

describe '#my_each_with_index' do
  let(:array) { [1, 2, 3] }
  context 'No block is given' do
    it 'returns an enumerator' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
  end
  context 'A block is given' do
    let(:my_test) { [] }
    let(:test) { [] }
    let(:indices) { [] }

    it 'calls the block for each element' do
      array.my_each_with_index { |item, _index| my_test << (item + 1) }
      array.each_with_index { |item, _index| test << (item + 1) }
      expect(my_test).to eql(test)
    end

    it 'It does not modify original array' do
      other_array = array
      array.my_each { |item| item + 1 }
      expect(array).to eql(other_array)
    end

    it 'Returns the indices' do
      array.my_each_with_index { |_item, index| indices << index }
      expect(indices).to eql([0, 1, 2])
    end
  end
end

describe '#my_select' do
  let(:array) { [1, 1, 1, 2, 3, 4] }
  context 'No block is given' do
    it 'returns an enumerator' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
  end
  context 'A block is given' do
    it 'return new array with elements that pass a condition' do
      expect(array.my_select { |item| item > 1 }).to eql([2, 3, 4])
    end
  end
end

describe '#my_all?' do
  let(:example1) { [1, 2, 3, 4] }
  let(:example2) { [5, 2, 3, 4] }
  let(:example3) { [nil, 2, 3, 4] }
  let(:example4) { %w[regex example test] }
  let(:example5) { %w[regex example test not] }
  let(:example6) { [3, 3, 3, 3, 3] }
  let(:example7) { [1, 3, 3, 3, 3] }
  context 'A block is given' do
    it 'returns true if all elements pass a test' do
      expect(example1.my_all? { |item| item < 5 }).to be(true)
    end
    it 'returns false if at lest one element does not pass the test' do
      expect(example2.my_all? { |item| item < 5 }).to be(false)
    end
  end
  context 'The argument given is nil' do
    it 'returns true if none of the elements evaluate to false' do
      expect(example1.my_all?).to be(true)
    end
    it 'returns false if at least of the elements evaluate to false' do
      expect(example3.my_all?).to be(false)
    end
  end
  context 'The argument given is a class' do
    it 'returns true if all elements are of the same class' do
      expect(example1.my_all?(Integer)).to be(true)
    end
    it 'returns false if at least one element is not of the same class' do
      expect(example3.my_all?(Integer)).to be(false)
    end
  end
  context 'The argument given is a Regexp' do
    it 'returns true if all elements match the regexp' do
      expect(example4.my_all?(/e/)).to be(true)
    end
    it 'returns false if at least one element does not match the regexp' do
      expect(example5.my_all?(/e/)).to be(false)
    end
  end
  context 'The argument given is a value' do
    it 'return true if all elements equal argument value' do
      expect(example6.my_all?(3)).to be(true)
    end
    it 'return false if at least one element is not equal argument value' do
      expect(example7.my_all?(3)).to be(false)
    end
  end
end

describe '#my_any?' do
  let(:example1) { [1, 2, 3, 4] }
  let(:example2) { [5, 6, 7, 8] }
  let(:example3) { [nil, 2, 3, 4] }
  let(:example4) { [false, nil, false] }
  let(:example5) { %w[were was is] }
  let(:example6) { %w[was is am] }
  let(:example7) { [3, 4, 5, 6, 7] }
  let(:example8) { [4, 5, 6, 7] }
  context 'A block is given' do
    it 'returns true if at lest one element pass the test' do
      expect(example1.my_any? { |item| item < 4 }).to be(true)
    end
    it 'returns false if all elements fail a test' do
      expect(example2.my_any? { |item| item < 5 }).to be(false)
    end
  end
  context 'The argument given is nil' do
    it 'returns true if at least one of the elements evaluate to true' do
      expect(example3.my_any?).to be(true)
    end
    it 'returns false if none of the elements evaluate to true' do
      expect(example4.my_any?).to be(false)
    end
  end
  context 'The argument given is a class' do
    it 'returns true if at least one element is of the same class' do
      expect(example1.my_any?(Integer)).to be(true)
    end
    it 'returns false if all elements are not of the same class' do
      expect(example1.my_any?(String)).to be(false)
    end
  end
  context 'The argument given is a Regexp' do
    it 'returns true if at least one element match the regexp' do
      expect(example5.my_any?(/e/)).to be(true)
    end
    it 'returns false if all elements do not match the regexp' do
      expect(example6.my_any?(/e/)).to be(false)
    end
  end
  context 'The argument given is a value' do
    it 'return true if  at least one element is equal to the argument value' do
      expect(example7.my_any?(3)).to be(true)
    end
    it 'return false if all elements are not equal to the argument value' do
      expect(example8.my_any?(3)).to be(false)
    end
  end
end

describe '#my_none?' do
  let(:example1) { [1, 2, 3, 4] }
  let(:example2) { [5, 6, 7, 8] }
  let(:example3) { [nil, 2, 3, 4] }
  let(:example4) { [false, nil, false] }
  let(:example5) { %w[were was is] }
  let(:example6) { %w[was is am] }
  let(:example7) { [3, 4, 5, 6, 7] }
  let(:example8) { [4, 5, 6, 7] }
  context 'A block is given' do
    it 'returns false if at lest one element pass the test' do
      expect(example1.my_none? { |item| item < 4 }).to be(false)
    end
    it 'returns true if all elements fail a test' do
      expect(example2.my_none? { |item| item < 5 }).to be(true)
    end
  end
  context 'The argument given is nil' do
    it 'returns false if at least one of the elements evaluate to true' do
      expect(example3.my_none?).to be(false)
    end
    it 'returns true if none of the elements evaluate to true' do
      expect(example4.my_none?).to be(true)
    end
  end
  context 'The argument given is a class' do
    it 'returns false if at least one element is of the same class' do
      expect(example1.my_none?(Integer)).to be(false)
    end
    it 'returns true if all elements are not of the same class' do
      expect(example1.my_none?(String)).to be(true)
    end
  end
  context 'The argument given is a Regexp' do
    it 'returns false if at least one element match the regexp' do
      expect(example5.my_none?(/e/)).to be(false)
    end
    it 'returns true if all elements do not match the regexp' do
      expect(example6.my_none?(/e/)).to be(true)
    end
  end
  context 'The argument given is a value' do
    it 'return false if  at least one element is equal to the argument value' do
      expect(example7.my_none?(3)).to be(false)
    end
    it 'return true if all elements are not equal to the argument value' do
      expect(example8.my_none?(3)).to be(true)
    end
  end
end

describe '#my_count' do
  let(:array) { [1, 2, 3, 4, 2, 5, 6, 2, 7, 8] }
  context 'A block is given' do
    it 'return the number of elements that pass the test' do
      expect(array.my_count { |item| item > 5 }).to eql(3)
    end
  end
  context 'An argument is given' do
    it 'returns the number of times the argument appears' do
      expect(array.my_count(2)).to eql(3)
    end
  end
  context 'No argument and no block is given' do
    it 'returns the length of the array' do
      expect(array.my_count).to eql(array.length)
    end
  end
end

describe '#my_map' do
  let(:array) { [1, 2, 3] }
  context 'No block is given' do
    it 'returns an enumerator' do
      expect(array.my_map).to be_an(Enumerator)
    end
  end
  context 'A block is given' do
    let(:test) { [] }
    it 'calls the block for each element' do
      array.each { |item| test << (item + 1) }
      expect(array.my_map { |item| item + 1 }).to eql(test)
    end

    it 'It modifies the original array' do
      original_array = array
      expect(array.my_map { |item| item + 1 }).to_not eql(original_array)
    end
  end
end

describe '#my_inject' do
  let(:array) { [1, 2, 3, 4] }
  context 'A block is given' do
    it 'returns the value given by the block' do
      expect(array.my_inject { |item1, item2| item1 * item2 }).to eql(24)
    end
  end
  context 'A symbol is given as an argument' do
    it 'returns the value of the operation given by the symbol' do
      expect(array.my_inject(:+)).to eql(10)
    end
  end
  context 'A string is given as an argument' do
    it 'returns the value of the operation given by the string' do
      expect(array.my_inject('+')).to eql(10)
    end
  end
  context 'An initial value is given and a symbol is given as an argument' do
    it 'returns the value of the operation given by the symbol with the initial value' do
      expect(array.my_inject(5, :+)).to eql(15)
    end
  end
end
