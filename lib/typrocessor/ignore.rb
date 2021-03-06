module Typrocessor
  class Ignore
    extend Typrocessor::RulesetMaker
    include Typrocessor::RegExpOwner

    attr_accessor :name, :expression, :inverted

    def initialize(name, expression, inverted=false)
      self.expression = expression
      self.name = name
      self.inverted = inverted
    end

    def ranges(string)
      inverted ? inverted_ranges(string) : regular_ranges(string)
    end

  private

    def regular_ranges(string)
      re = get_regexp

      ranges = []
      match = re.match(string)

      while !match.nil? do
        break if !ranges.empty? && (match.begin(0) == ranges.last.first || match.end(0) == ranges.last.last)
        ranges << [match.begin(0), match.end(0)]
        next_start = match.end(0)
        match = re.match(string, next_start)
      end

      ranges
    end

    def inverted_ranges(string)
      re = get_regexp

      ranges = []
      match = re.match(string)
      next_start = 0

      while !match.nil? do
        break if !ranges.empty? && (match.begin(0) == ranges.last.first || match.end(0) == ranges.last.last)
        ranges << [next_start, match.begin(0)]
        next_start = match.end(0)
        match = re.match(string, next_start)
      end

      ranges << [next_start, string.size] if next_start != string.size

      ranges
    end

  end
end
