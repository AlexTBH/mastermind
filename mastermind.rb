INPUT_TEXT = [
    "Guess what color the first slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the second slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the third slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the fourth slot holds, choose between Blue, Green, Orange, Yellow, Pink & White"
]

CREATOR_COLORS = ["blue", "green", "orange", "yellow", "pink", "white"]

class Game
    attr_accessor :secret_code

    def initialize
        @guesser = nil
        @creator = nil
        @current_guesses_counter = nil
        @secret_code = []

        create_guesser
        guess_player_input
    end

    def creator_or_guesser
        puts "Type C if you want to be the creator, else type G if you want to be the guesser"
        input = gets.chomp
        if input.capitalize == "C"
            return creator
        elsif input.capitalize == "G"
            return create_guesser
        else
            puts "Type either C or G"
            creator_or_guesser
        end
    end

    def create_guesser
        puts "Type the name of the Guesser"
        input = gets.chomp
        @guesser = Guesser.new(input)
    end

    def secret_code_creation
        4.times { secret_code.push CREATOR_COLORS.sample}
    end

    def guess_player_input
        4.times do |i|
            puts INPUT_TEXT[i]
            input = gets.chomp
            while (!valid_input?(input))
                input = gets.chomp
            end
            @guesser.inputs << input
        end
        return @guesser.inputs
    end

    def valid_input?(input)
        return input if CREATOR_COLORS.any?(input.downcase)
        puts "You have not choosen a valid color. choose again"
    end

end

class Guesser

    attr_reader :name
    attr_accessor :inputs, :points

    def initialize(name, inputs=nil, points=nil)
        @name = name
        @points = nil
        @inputs = []

    end

end

class Creator
end

x = Game.new