require './processing.rb'

def user_input
    puts 'Вводите массив (все числа через пробел): '
    arr = gets.chomp.split.map(&:to_i)
end

def file_input
    puts 'Введите путь к файлу: '
    path = gets.chomp

    if path.nil? || path.empty? then
        raise ArgumentError, 'Путь к файлу равен nil или пуст'
    end
    unless File.exist?(path) then
        raise ArgumentError, 'Файл не существует'
    end

    arr = []
    File.open(path, 'r') do |file|
        arr = file.read.split(' ').map(&:to_i)
    end

    arr
end

def input_choice
    arr = []
    loop do
        puts 'Выберите способ ввода данных: '
        puts '1. С клавиатуры'
        puts '2 - Из файла'
    
        choice = gets.chomp.to_i
    
        case choice
        when 1
            arr = user_input
            break
        when 2
            arr = file_input
            break
        else
            puts 'Нет такого способа'
        end
    end

    puts "\n\n"
    puts "Введенный массив: #{arr.join(' ')}"
    arr
end

def menu
    loop do
        puts 'Выберите задачу:'
        puts '1 - Проверить, является ли элемент глобальным максимумом'
        puts '2 - Проверить, является ли элемент локальным минимумом'
        puts '3 - Циклический свдиг массива влево на одну позицию'
        puts '4 - Вывести сначала элементы с четными индексами, потом - с нечетными'
        puts '5 - Построить списки L1 и L2, где L1 - это список уникальных элементов исходного массива, а элемент с номером i списка L2 указывает сколько раз элемент с этим номером из списка L1 повторяется в исходном'
        puts '0 - Выход'
    
        task = gets.chomp.to_i
        puts "\n\n"
    
        case task
        when 1
            is_global_maximum
        when 2
            is_local_minimum
        when 3
            cyclic_shift
        when 4
            even_odd_index
        when 5
            build_L1_L2
        when 0
            exit
        else
            puts 'Нет такой задачи'
        end

        puts "\n\n"
    end
end

def index_input(arr)
    puts 'Введите индекс: '
    index = gets.chomp.to_i

    unless index.between?(0, arr.length - 1)
        raise 'Индекс некорректен'
    end

    index.to_i
end

def is_global_maximum
    arr = input_choice

    begin
        index = index_input(arr)
    rescue => e
        puts "#{e.message}"
        return
    end

    if Processing.is_global_maximum(arr, index) then
        puts "Элемент #{arr[index]} глобальный максимум"
    else
        puts "Элемент #{arr[index]} не глобальный максимум"
    end
end

def is_local_minimum
    arr = input_choice

    begin
        index = index_input(arr)
    rescue => e
        puts "#{e.message}"
        return
    end

    if index < 0 || index > arr.length - 1 then
        puts 'Индекс некорректен'
        return
    end

    if Processing.is_local_minimum(arr, index) then
        puts "Элемент #{arr[index]} локальный минимум"
    else
        puts "Элемент #{arr[index]} не локальный минимум"
    end
end

def cyclic_shift
    arr = input_choice

    shifted_arr = Processing.cyclic_shift(arr)

    puts "Сдвинутый массив: #{shifted_arr.join(' ')}"
end

def even_odd_index
    arr = input_choice

    even_odd = Processing.even_odd_index(arr)

    puts "Полученный массив: #{even_odd.join(' ')}"
end

def build_L1_L2
    arr = input_choice

    lists = Processing.build_L1_L2(arr)

    puts "L1: #{lists[0]. join(' ')}"
    puts "L2: #{lists[1]. join(' ')}"
end

menu