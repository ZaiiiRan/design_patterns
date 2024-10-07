require 'minitest/autorun'
require './array_processor.rb'

class Tests < Minitest::Test
    attr_reader :processor

    def setup
        self.processor = Array_processor.new([1, 5, 2, 2, -7, 3, 4, 5, 33, 6])
    end

    def test_count_equal_2
        assert_equal 2, self.processor.count { |x| x == 2 }
    end

    def test_count_even
        assert_equal 4, self.processor.count { |x| x.even? }
    end

    private
    attr_writer :processor
end