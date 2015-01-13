require_relative "../lib/custom_enumerable"

class ArrayWrapper

  include CustomEnumerable

  def initialize(*items)
    @items = items.flatten
  end

  def each(&block)
    @items.each(&block)
    self
  end

  def ==(other)
    @items == other
  end

end

RSpec.describe CustomEnumerable do

  context "map" do

    it 'maps the numbers multiplying them by 2' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.map do |n|
        n * 2
      end

      expect(result).to eq([2, 4, 6, 8])
    end

  end

  context 'find' do

    it 'finds the item given a predicate' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find do |element|
        element == 3
      end

      expect(result).to eq(3)
    end

    it 'returns the ifnone value if no item is found' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find(lambda {0}) do |element|
        element < 1
      end
      expect(result).to eq(0)
    end

    it "returns nil if it can't find anything" do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find do |element|
        element == 10
      end
      expect(result).to be_nil
    end

    it "returns nil if it is empty" do
      items = ArrayWrapper.new
      result = items.find do |element|
        element == 10
      end
      expect(result).to be_nil
    end

    it "finds nil" do
      items = ArrayWrapper.new(true, false, nil, 10)
      result = items.find(true) do |element|
        element.nil?
      end
      expect(result).to be_nil
    end

  end

  context 'find_all' do

    it 'finds all the numbers that are greater than 2' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find_all do |element|
        element > 2
      end
      expect(result).to eq([3,4])
    end

    it 'does not find anything' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find_all do |element|
        element > 4
      end
      expect(result).to be_empty
    end

  end

  context "first" do

    it 'returns the first element inside a collection' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      expect(items.first).to eq(1)
    end

    it 'returns nil if the collection is empty' do
      items = ArrayWrapper.new
      expect(items.first).to be_nil
    end

  end

  context "reduce" do

    it 'sums all numbers' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.reduce(0) do |accumulator,element|
        accumulator + element
      end
      expect(result).to eq(10)
    end

    it 'returns the accumulator if no value was provided' do
      items = ArrayWrapper.new
      result = items.reduce(50) do |accumulator,element|
        accumulator + element
      end
      expect(result).to eq(50)
    end

    it 'executes the operation provided' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.reduce(0, :+)
      expect(result).to eq(10)
    end

    it "fails if both a symbol and a block are provided" do
      items = ArrayWrapper.new(1, 2, 3, 4)
      expect do
        items.reduce(0, :+) do |accumulator,element|
          accumulator + element
        end
      end.to raise_error(ArgumentError, "you must provide either an operation symbol or a block, not both")
    end

    it 'fails if the operation provided is not a symbol' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      expect do
        items.reduce(0, '+')
      end.to raise_error(ArgumentError, "the operation provided must be a symbol")
    end

    it 'executes the operation provided without an initial value' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.reduce(:+)
      expect(result).to eq(10)
    end

    it 'executes the block provided without an initial value' do
      items = ArrayWrapper.new(1, 2, 3, 4)
      result = items.reduce do |accumulator,element|
        accumulator + element
      end
      expect(result).to eq(10)
    end

    it 'returns nil if the collection is empty' do
      items = ArrayWrapper.new
      result = items.reduce(:+)
      expect(result).to be_nil
    end

  end

  context 'max' do

    it 'produces 4 as the max result' do
      items = ArrayWrapper.new(1, 2, 3, 4, -1, -4, -10)
      expect(items.max).to eq(4)
    end

    it 'produces 1 as the max result' do
      items = ArrayWrapper.new(1)
      expect(items.max).to eq(1)
    end

    it 'produces nil if it is empty' do
      items = ArrayWrapper.new
      expect(items.max).to be_nil
    end

  end

  context 'min' do

    it 'produces -10 as the min result' do
      items = ArrayWrapper.new(1, 2, 3, 4, -1, -4, -10)
      expect(items.min).to eq(-10)
    end

    it 'produces 1 as the max result' do
      items = ArrayWrapper.new(1)
      expect(items.min).to eq(1)
    end

    it 'produces nil if it is empty' do
      items = ArrayWrapper.new
      expect(items.min).to be_nil
    end

  end

end