if ARGV.length != 0 then
    puts "Hi, #{ARGV[0]}\n\n"

    puts "What is your favourite programming language?\n\n"

    lang = $stdin.gets

    puts "\n"

    case lang.chomp 
        when 'ruby'
            puts 'Ruby IS THE BEST'
        when 'c'
            puts 'Oh so you\'re old'
        when 'c++'
            puts 'maaaaaan, change your programming language please'
        when 'python'
            puts 'very slow'
        when 'golang'
            puts 'good'
        else
            puts 'I don\'t know this language'
    end

    puts "\n\n\n\n"

    puts "Now enter any Ruby command\n\n"

    ruby_command = $stdin.gets.chomp

    puts eval(ruby_command)

    puts "\n\nOk, enter any OS command\n\n"

    os_command = $stdin.gets.chomp

    system(os_command)
else
    puts "Please, enter your name in arguments"
end