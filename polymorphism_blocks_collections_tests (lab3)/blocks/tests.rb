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

    def test_group_by_even
        assert_equal({ true => [2, 2, 4, 6], false => [1, 5, -7, 3, 5, 33] }, self.processor.group_by { |x| x.even? })
    end

    def test_group_by_negative
        assert_equal({ true => [-7], false => [1, 5, 2, 2, 3, 4, 5, 33, 6] }, self.processor.group_by { |x| x < 0 })
    end

    def test_partition_even
        assert_equal [[2, 2, 4, 6], [1, 5, -7, 3, 5, 33]], self.processor.partition {|x| x.even?}
    end

    def test_partition_positive
        assert_equal [[1, 5, 2, 2, 3, 4, 5, 33, 6], [-7]], self.processor.partition {|x| x > 0}
    end

    def test_take_while_odd
        assert_equal [1, 5], self.processor.take_while { |x| x.odd? }
    end

    def test_take_while_positive
        assert_equal [1, 5, 2, 2], self.processor.take_while { |x| x > 0 }
    end

    def test_min_count_of_digits
        assert_equal 1, self.processor.min { |a, b| a.abs.to_s <=> b.abs.to_s }
    end

    def test_min_even
        assert_equal 2, self.processor.min { |a, b| (a.even? ? a: Float::INFINITY) <=> (b.even? ? b: Float::INFINITY) }
    end

    def test_filter_map_incr_if_even
        assert_equal [3, 3, 5, 7], self.processor.filter_map { |x| x + 1 if x.even? }
    end

    def test_filter_map_square_if_odd
        assert_equal [1, 25, 49, 9, 25, 1089], self.processor.filter_map { |x| x * x if x.odd? }
    end

    private
    attr_writer :processor
end