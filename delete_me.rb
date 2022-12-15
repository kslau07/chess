# delete me, delete file

def get_input
  loop do
    puts 'input a number between 1-2'
    input = gets.chomp
    return input if input.match(/^[1-2]${1}/)
    puts 'wrong input'
  end
end

user_input = get_input
puts user_input