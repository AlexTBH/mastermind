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
        @turns = 0
        @player_creator = false

    end

    def play
        creator_or_guesser
        secret_code_creation

        while @turns < 12
            player_guess_input
            compare_results

            break if @guesser.inputs == @creator.secret_code
            @guesser.inputs = []
        end
        game_over?
    end

    def game_over?
        if @guesser.inputs == @creator.secret_code
            puts "\n"
            puts "You win!"
        else
            puts "\n"
            puts "You lose"
        end
    end
    
    def computer_guesser
        #Work on this next
    end

    def creator_or_guesser
        puts "Type C if you want to be the creator, else type G if you want to be the guesser"
        input = gets.chomp
        if input.capitalize == "C"
            return create_creator
        elsif input.capitalize == "G"
            return create_guesser
        else
            puts "Type either C or G"
            creator_or_guesser
        end
    end

    def create_guesser
        @guesser = Guesser.new()
    end

    def create_creator
        @creator = Creator.new()
        @player_creator = true
    end

    #Work on this method later. This will let the player be the creator of the secret code.
    def secret_code_creation
        if (@player_creator != false)
            puts "Choose the colors for your secret code. Choose between the colors \n #{Text::CREATOR_COLORS}"
            4.times do
                input = gets.chomp
                while (!valid_input?(input))
                    input = gets.chomp
                end
                @creator.secret_code << input
            end
            puts "\n #{@creator.secret_code}"
        else
            @creator = Creator.new()
            4.times {@creator.secret_code.push Text::CREATOR_COLORS.sample}
            puts @creator.secret_code
        end
    end

    def player_guess_input
        4.times do |i|
            puts Text::INPUT_TEXT[i]
            input = gets.chomp
            while (!valid_input?(input))
                input = gets.chomp
            end
            puts "\n"
            @guesser.inputs << input
        end
    end

    def compare_results
        @guesser.inputs.each_with_index do |code, idx|
            if @guesser.inputs[idx] == @creator.secret_code[idx]
                puts "#{code} color in slot #{idx+1} was correct!"
            elsif @creator.secret_code.any? @guesser.inputs[idx]
                puts "The color #{code} was correct, however in the wrong slot."
            else
                puts "#{code} color in slot #{idx+1} was incorrect and is not in the secret code."
            end
        end
        puts "\n"
        @turns += 1
    end

    def valid_input?(input)
        return input if Text::CREATOR_COLORS.any?(input.downcase)
        puts "You have not choosen a valid color. choose again"
    end

end

class Guesser
    attr_reader :name
    attr_accessor :inputs, :points

    def initialize(inputs=nil)
        @inputs = []
    end
end

class Creator

    attr_accessor :secret_code
    def initialize()
        @secret_code = []
    end
end

x = Game.new.play