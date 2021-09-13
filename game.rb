require 'yaml'

def choose_word(min,max)
    dictionary = []
    hidden_word = ""

    words = File.open('5desk.txt', 'r')
    words.each do |word|
        dictionary << word.chomp
    end

    until hidden_word.length >= min && hidden_word.length <= max
        hidden_word = dictionary[rand(dictionary.length - 1)]
    end
    return hidden_word.downcase
end

def hangman(wrong_guesses)
    puts "    _____"

    if wrong_guesses == 8
        puts "    |   |"
        puts "    |   O"
        puts "    |  /|\\"
        puts "    |  / \\"
        puts "    |" 
        puts " You are out of guesses"
    elsif wrong_guesses == 7
        puts "    |   |"
        puts "    |   O"
        puts "    |  /|\\"
        puts "    |  /"
        puts "    |"
        puts "This is your last guess"
    elsif wrong_guesses == 6
        puts "    |   |"
        puts "    |   O"
        puts "    |  /|\\ "
        puts "    |"
        puts "    |"
        puts "You have 2 guesses remaining"
    elsif wrong_guesses == 5
        puts "    |   |"
        puts "    |   O"
        puts "    |  /|"
        puts "    |"
        puts "    |"
        puts "You have 3 guesses remaining"
    elsif wrong_guesses == 4
        puts "    |   |"
        puts "    |   O"
        puts "    |   |"
        puts "    |"
        puts "    |"
        puts "You have 4 guesses remaining"
    elsif wrong_guesses == 3
        puts "    |   |"
        puts "    |   O"
        puts "    |"
        puts "    |"
        puts "    |"
        puts "You have 5 guesses remaining"
    elsif wrong_guesses == 2
        puts "    |   |"
        puts "    |"
        puts "    |"
        puts "    |"
        puts "    |" 
        puts "You have 6 guesses remaining"
    elsif wrong_guesses == 1
        puts "    |"
        puts "    |"
        puts "    |"
        puts "    |"
        puts "    |" 
        puts "You have 7 guesses remaining"
    end
end

def draw_word(string)
    puts "             #{string}"
    puts ""
end

def grab_guess
    guess = ''
   until guess.match(/^[[:alpha:]]+$/) && guess.length == 1 ||
guess.downcase.match("save")
    puts "Which letter are you guessing?"
    guess = gets.chomp.downcase

    if guess.downcase.match("save")
        save_game($new_game)
        return "saved"
    end
   end
return guess
end

def hide_word(secret_word)
    hidden_word = ""
    i = 0
  
    until i == secret_word.length
      hidden_word << "_"
      i += 1
    end
    return hidden_word
  end

def replace_letter(letter, secret_word, hidden_word)
    hidden_word = hidden_word.tr(" ", "")

    if hidden_word.length == secret_word.length
        i = 0
        until i == hidden_word.length
            if secret_word[i] == letter
                hidden_word[i] = letter
            end
            i += 1
        end
    else
        puts "ErrorCode: 123"
    end

    visible_word = ""
    hidden_word.each_char do |c|
        visible_word << c + " "
    end
    return visible_word
end

def play_again
    again = ""
    until again == "Y" || again == "N"
        puts "Do you want to play again? Y/n"
        secret_word = choose_word(5, 12)
        hidden_word = hide_word(secret_word)  
    
        gets.chomp.upcase == "Y" ? new_game = Hangman.new(secret_word, hidden_word, 0) : return
    end
end

def save_game(hangman)
    yaml = YAML::dump(
      'secret_word' => secret_word,
      'hidden_word' => hidden_word,
      'guesses' => guesses
    )
    
    File.open("saved.yaml", 'w') { |file| file.write yaml}
    puts "Game Saved!"
  end
  
def load_game
    game_file = YAML.safe_load(File.open("lib/saved.yaml", 'r'))
  
    secret_word = game_file['secret_word']
    hidden_word = game_file['hidden_word']
    guesses = game_file['guesses']
  
    game = Hangman.new(secret_word, hidden_word, guesses) 
end

class Hangman
    attr_accessor :secret_word, :hidden_word, :guesses
  
    def initialize(secret_word, hidden_word, guesses)
      @secret_word = secret_word
      @hidden_word = hidden_word
      @guesses = guesses.to_i
  
      puts "Your secret word has #{@hidden_word.length} characters."
      puts "You can save your game at any time by typing 'save'."
  
      until @guesses == 8
        letter = grab_guess
        if letter == "saved"
          return
        end
  
        @secret_word.include?(letter) ? @hidden_word = replace_letter(letter, @secret_word, @hidden_word) : @guesses += 1
        hangman(@guesses)
        draw_word(@hidden_word) 
        if @hidden_word.include?("_") == false
          @guesses = 8
        end 
      end
      @guesses == 8 ? play_again : return
    end
  end

which_game = ""

until which_game.match("L") || which_game.match("N")
  puts "Would you like to load (L) a saved game or play a new (N) game?"
  which_game = gets.chomp.upcase
end

if which_game.match("L")
  load_game
elsif which_game.match("N")
  secret_word = choose_word(5, 12)
  hidden_word = hide_word(secret_word)

  $new_game = Hangman.new(secret_word, hidden_word, 0)
end
