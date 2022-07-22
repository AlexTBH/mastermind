module Text

INPUT_TEXT = [
    "Guess what color the first slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the second slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the third slot holds, choose between Blue, Green, Orange, Yellow, Pink & White",
    "Guess what color the fourth slot holds, choose between Blue, Green, Orange, Yellow, Pink & White"
]

CREATOR_COLORS = ["blue", "green", "orange", "yellow", "pink", "white"]

end

class Game
    include Text

    def initialize
        @guesser = nil
        @creator = nil
        @current_guesses_counter = nil
        @player_creator = false

        create_creator
        secret_code_creation
        create_guesser
        guess_player_input
        compare_results
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

    #Will create this method later when I am done with the game. This method will let the player be the creator of the secret code versus the computer.
    def create_creator
        @creator = Creator.new()
    end

    def secret_code_creation
        if (@player_creator != false)
            puts "Nej"
        else
            4.times {@creator.secret_code.push Text::CREATOR_COLORS.sample}
            puts @creator.secret_code
        end
    end

    def guess_player_input
        4.times do |i|
            puts Text::INPUT_TEXT[i]
            input = gets.chomp
            while (!valid_input?(input))
                input = gets.chomp
            end
            @guesser.inputs << input
        end
    end

    #Fortsätt här!
    def compare_results
        @guesser.inputs.each_with_index do |code, idx|
            if @guesser.inputs[idx] == @creator.secret_code[idx]
                puts "#{code} color in slot #{idx+1} was correct!"
            else
                puts "#{code} color in slot #{idx+1} was incorrect!"
            end
        end
    end

    def valid_input?(input)
        return input if Text::CREATOR_COLORS.any?(input.downcase)
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
    attr_accessor :secret_code
    def initialize()
        @secret_code = []
    end
end

x = Game.new