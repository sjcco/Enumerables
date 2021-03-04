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
      array.my_each_with_index { |item, index| my_test << (item + 1) }
      array.each_with_index { |item, index| test << (item + 1) }
      expect(my_test).to eql(test)
    end

    it 'It does not modify original array' do
      other_array = array
      array.my_each { |item| item + 1 }
      expect(array).to eql(other_array)
    end

    it 'Returns the indices' do
      array.my_each_with_index { |item, index| indices << index }
      expect(indices).to eql([0, 1, 2])
    end
  end
end
