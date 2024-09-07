def is_prime(number)
    if number <= 1 then
        return false
    end

    for divider in 2..Math.sqrt(number).to_i do
        if number % divider == 0 then
            return false
        end
    end

    return true
end

def max_prime_divider(number)
    number = number.abs

    if number <= 1
        return 'This number does not satisfy the condition'
    end

    max_divider = 0

    for divider in 2...number.to_i do
        if number % divider == 0 && is_prime(divider) then
            max_divider = divider
        end
    end

    if (max_divider == 0) then
        return number
    end
    return max_divider
end



def product_of_digits_not_divisible_by_5(number)
    number = number.abs
    res = 1
    has_not_5_or_0 = false

    while number > 0 
        digit = number % 10
        number /= 10

        if digit == 1
            has_not_5 = true
            next
        elsif digit % 5 != 0
            has_not_5_or_0 = true
            res *= digit
        end
    end

    if has_not_5_or_0 then
        return res
    else
        return 0
    end
end




puts "Max prime divider: #{max_prime_divider(26)}"
puts "Product of digits not divisible by 5: #{product_of_digits_not_divisible_by_5(2535)}"
