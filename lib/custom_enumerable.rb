module CustomEnumerable

  def map(&block)
    result = []
    each do |element|
      result << block.call(element)
    end
    result
  end

  def find(ifnone = nil, &block)
    result = ifnone
    each do |element|
      if block.call(element)
        result = element
        break
      end
    end
    result
  end

  def find_all(&block)
    result = []
    each do |element|
      if block.call(element)
        result << element
      end
    end
    result
  end

  def first
    found = nil
    each do |element|
      found = element
      break
    end
    found
  end

  def reduce(accumulator = nil, operation = nil, &block)
    if accumulator.nil? && operation.nil? && block.nil?
      raise ArgumentError, "you must provide an operation or a block"
    end

    if operation.nil? && block.nil?
      operation = accumulator
      accumulator = nil
    end

    if operation && block
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    end

    block = case operation
              when Symbol
                lambda { |acc, value| acc.send(operation, value) }
              when nil
                block
              else
                raise ArgumentError, "the operation provided must be a symbol"
            end

    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end

    index = 0

    each do |element|
      unless ignore_first && index == 0
        accumulator = block.call(accumulator, element)
      end
      index += 1
    end
    accumulator
  end

  def min
    reduce do |accumulator,element|
      accumulator > element ? element : accumulator
    end
  end

  def max
    reduce do |accumulator,element|
      accumulator < element ? element : accumulator
    end
  end


end