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

puts max_prime_divider(26)