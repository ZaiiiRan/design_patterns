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
        elsif digit % 5 != 0 then
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



def gcn(a, b)
    if a < b then
        a, b = b, a
    end

    while b != 0
        a, b = b, a % b
    end

    return a
end

def greatest_common_divider_with_conditions(number)
    number = number.abs

    if (number == 0) then
        return 'This number does not satisfy the condition'
    end

    # Ищем ищем произведение цифр
    tmp = number
    product_of_digits = 1
    
    while tmp > 0
        digit = tmp % 10
        tmp /= 10

        if digit == 0 then
            product_of_digits = 0
            break
        elsif digit == 1 then
            next
        else
            product_of_digits *= digit
        end
    end

    if product_of_digits == 1 then
        return 1
    end

    # Ищем максимальный непростой нечетный делитель 
    max_divider = 1
    for divider in 1..number do
        if number % divider == 0 && divider % 2 != 0 && !is_prime(divider) then
            max_divider = divider
        end
    end

    if product_of_digits == 0 then
        return max_divider
    end

    return gcn(product_of_digits, max_divider)
end

puts "Max prime divider: #{max_prime_divider(26)}"
puts "Product of digits not divisible by 5: #{product_of_digits_not_divisible_by_5(2535)}"
puts  "Greatest common divider with conditions: #{greatest_common_divider_with_conditions(49)}"