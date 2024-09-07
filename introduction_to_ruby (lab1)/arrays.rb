def min_for(array)
    min = array[0]

    for i in 1...array.size do
        if array[i] < min then
            min = array[i]
        end
    end

    return min
end

def min_while(array)
    min = array[0]
    i = 1

    while i < array.size
        if array[i] < min then
            min = array[i]
        end
        i += 1
    end

    return min
end

def num_of_first_pos_el_for(array)
    for i in 0...array.size do
        if array[i] > 0 then
            return i
        end
    end

    return -1
end

def num_of_first_pos_el_while(array)
    i = 0

    while i < array.size
        if array[i] > 0 then
            return i
        end
        i += 1
    end

    return -1
end

def find_element_for(array, value)
    for i in 0...array.size do
        if array[i] == value then
            return i
        end
    end

    return -1
end

def find_element_while(array, value)
    i = 0

    while i < array.size
        if array[i] == value then
            return i
        end
        i += 1
    end

    return -1
end

def find_elements_for(array, value)
    finded = Array.new

    for i in 0...array.size do
        if array[i] == value then
            finded << i
        end
    end

    return finded
end

def find_elements_while(array, value)
    finded = Array.new
    i = 0

    while i < array.size
        if array[i] == value then
            finded << i
        end
        i += 1
    end

    return finded
end


def read_array_from_file(path)
    begin
        array = File.read(path).split

        for i in 0...array.size do
            if array[i] =~ /\d/
                array[i] = array[i].to_i
            else
                raise "No number found in array"
            end
        end
    
        return array
    rescue => e 
        puts "Error: #{e.message}"
        exit
    end
end


if ARGV.size >= 2 then
    arr = read_array_from_file(ARGV[1])

    if arr.size == 0 then
        puts "Array is empty. Why would you do anything with emptiness?))"
        exit
    end

    puts "Array: #{arr.join(', ')}\n\n"

    case ARGV[0].to_i
        when 1 
            puts "Finded minimum using for: #{min_for(arr)}"
        when 2
            puts "Finded minimum using while: #{min_while(arr)}"
        when 3
            puts "Number of finded first positive element using for: #{num_of_first_pos_el_for(arr)}"
        when 4
            puts "Number of finded first positive element using while: #{num_of_first_pos_el_while(arr)}"
        when 5
            puts "Enter value"

            val = $stdin.gets.chomp.to_i

            puts "\nFirst match index (using for): #{find_element_for(arr, val)}"
        when 6
            puts "Enter value"

            val = $stdin.gets.chomp.to_i

            puts "\nFirst match index (using while): #{find_element_while(arr, val)}"
        when 7
            puts "Enter value"

            val = $stdin.gets.chomp.to_i

            puts "\nMatch indices (using for): #{find_elements_for(arr, val).join(', ')}"
        when 8
            puts "Enter value"

            val = $stdin.gets.chomp.to_i

            puts "\nMatch indices (using while): #{find_elements_while(arr, val).join(', ')}"
        else
            puts "Invalid action number"
    end
else
    puts 'Enter 2 parameters: the first is the method, the second is the path to the file'
end