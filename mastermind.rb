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
        @computer_hints = []
        @save_colors = []
    end

    def play
        creator_or_guesser
        create_players
        secret_code_creation

        while @turns < 12
            if @player_creator != true
                player_guess_input
                compare_results
                break if @guesser.inputs == @creator.secret_code
                @guesser.inputs = []
            else
                computer_guesser
                compare_results
                break if @guesser.inputs == @creator.secret_code
                hint_to_computer
            end

            @turns += 1
        end
        game_over?
    end

    def game_over?
        if @guesser.inputs == @creator.secret_code
            puts "\n"
            puts "Guesser wins!!"
        else
            puts "\n"
            puts "Creator loses!!"
        end
    end
    
    def computer_guesser
        4.times do |i|
            if (@computer_hints[i] == "O")
                next                
            elsif (@computer_hints[i] == "S" || @computer_hints.empty? || @save_colors.empty?)
                @guesser.inputs[i] = Text::CREATOR_COLORS.sample
            elsif (@computer_hints[i] == "X")
                @guesser.inputs[i] = @save_colors.sample                             
            end
        end

        puts "\n"
        puts "The computer has made it guesses on the secret code!"
        puts "Computer guesses: #{@guesser.inputs.join(" ")}"
        puts "\n"
        @computer_hints = []
    end

    def hint_to_computer
        puts "Give hints to the computer which color and slot is correct!"
        puts "Type X if the color is not in the secret code, O if it is the correct color and slot, S if it the right color but wrong slot."
            4.times do |i|
                input = gets.chomp.capitalize
                while (input != "X" && input != "O" && input != "S")
                    puts "Please type the letter X, O or S"
                    input = gets.chomp.capitalize
                end
                if input == "X"
                    Text::CREATOR_COLORS.delete_if {|color| color == @guesser.inputs[i]}
                elsif input == "S"
                    save_color_input(@guesser.inputs[i])
                end
                @computer_hints << input
            end
    end

    def save_color_input(input)
        if @save_colors.include?(input)
            return
        else
            @save_colors << input
        end
    end

    def creator_or_guesser
        puts "Type C if you want to be the creator, else type G if you want to be the guesser"
        input = gets.chomp
        if input.capitalize == "C"
            @player_creator = true
        elsif input.capitalize == "G"
            @player_creator = false
        else
            puts "Type either C or G"
            creator_or_guesser
        end
    end

    def create_players
        @creator = Creator.new()
        @guesser = Guesser.new()
    end
    
    #Work on this method later. This will let the player be the creator of the secret code.
    def secret_code_creation
        if (@player_creator != false)
            puts "Choose the colors for your secret code. Choose between the colors \n #{Text::CREATOR_COLORS.join(" ")}"
            4.times do
                input = gets.chomp
                while (!valid_input?(input))
                    input = gets.chomp
                end
                @creator.secret_code << input
            end
            puts "Your secret code is :\n #{@creator.secret_code.join(" ")}"
        else
            @creator = Creator.new()
            4.times {@creator.secret_code.push Text::CREATOR_COLORS.sample}
        end
    end

    def player_guess_input
        4.times do |i|
            puts Text::INPUT_TEXT[i]
            input = gets.chomp
            while (!valid_input?(input))
                input = gets.chomp
            end
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