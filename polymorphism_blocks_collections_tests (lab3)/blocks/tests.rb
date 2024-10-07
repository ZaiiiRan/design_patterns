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

    private
    attr_writer :processor
end