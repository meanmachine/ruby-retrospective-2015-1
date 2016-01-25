class RationalSequence
  include Enumerable

  def initialize(elements_count)
    @length = elements_count
  end

  def each
    return if @length.zero?
    rational_sum = 2
    loop do
      (1..rational_sum.pred).each do |number|
        yield reciprocal Rational(number, rational_sum - number)
      end
      rational_sum += 1
    end
  end

  def reciprocal(n)
    (n.numerator + n.denominator).even? ? n : 1/n
  end

  def to_a
    rational_sequence = []
    enum_for(:each).take_while do |rational|
      rational_sequence << rational
      rational_sequence.uniq.length < @length
    end
    rational_sequence.uniq
  end
end

class PrimeSequence
  include Enumerable

  def initialize(elements_count)
    @length = elements_count
  end

  def each
    number = 2
    counter = 0
    while counter < @length do
      if number.prime?
        yield number
        counter += 1
      end
      number += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(elements_count, first: 1, second: 1)
    @length = elements_count
    @first  = first
    @second = second
  end

  def each
    previous, current = @first, @second
    @length.times.each do
      yield previous
      previous, current = current, previous + current
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    group_one = [Rational(1,1)]
    group_two = [Rational(1,1)]
    rationals = RationalSequence.new(n).to_a
    rationals.each do |rational|
      if rational.numerator.prime? and rational.denominator.prime?
        group_one << rational
      else
        group_two << rational
      end
    end
    group_one.reduce(&:*) / group_two.reduce(&:*)
  end

  def aimless(n)
    primes = PrimeSequence.new(n).to_a
    primes << 1 if n.odd?
    prime_couples = primes.each_slice(2).map(&:to_a)
    prime_rationals = prime_couples.map { |couple| Rational(*couple) }
    prime_rationals.reduce(&:+)
  end

  def worthless(n)
    nth_fibonacci     = FibonacciSequence.new(n).to_a.last
    rationals         = RationalSequence.new(1)
    rational_sequence = []
    rationals.take_while do |rational|
      rational_sequence << rational
      rational_sequence.uniq.reduce(&:+) <= nth_fibonacci
    end
    rational_sequence.uniq[0..-2]
  end
end

class Numeric

  def prime?
    (2..pred).all? { |number| self.remainder(number).nonzero? }
  end
end