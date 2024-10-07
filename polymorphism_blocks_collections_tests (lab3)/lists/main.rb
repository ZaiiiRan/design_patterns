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
    while true 
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

    puts "Введенный массив: #{arr.join(' ')}"
    arr
end


def menu
    while true
        puts 'Выберите задачу:'
        puts '1 - Проверить, является ли элемент глобальным максимумом'
        puts '2 - Проверить, является ли элемент локальным минимумом'
        puts '0 - Выход'
    
        task = gets.chomp.to_i
    
        case task
        when 1
            is_global_maximum
        when 2
            is_local_minimum
        when 0
            exit
        else
            puts 'Нет такой задачи'
        end
    end
end

def is_global_maximum
    arr = input_choice

    puts 'Введите индекс: '
    index = gets.chomp.to_i

    if index < 0 || index > arr.length - 1 then
        puts 'Индекс некорректен'
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

    puts 'Введите индекс: '
    index = gets.chomp.to_i

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


menu