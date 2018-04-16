class Mastermind
  #initialize general values
  def initialize
    @guess_correct = 0
    @rounds_used = []
    @round_counter = 1
    @black_peg = 0
    @white_peg = 0
    @code_made = false
    choose_player
  end

  #let the player choose wheter to guess or make codes
  def choose_player
    puts 'Who is the guesser (player/com)'
    @guesser = gets.chomp
    while @guesser != 'player' && @guesser != 'com'
      @guesser = gets.chomp
    end
    @coder = @guesser == 'player' ? 'com' : 'player'
    if @coder == 'com'
      while @game_over != true
        puts 'Please enter code ex. 1 2 3 4'
        puts 'Round: ' + @round_counter.to_s
        player_guess
      end
    elsif @coder == 'player'
      player_make_code
      com_guess
    end
  end

  def player_make_code
    puts 'What would the code be? ex. 1 1 2 3'
    @rand_code = gets.chomp.split(' ').map! { |num| num.to_i }
    @compare = @rand_code.dup
    @code_made = true
  end

  def player_guess
    @guess = gets.chomp.split(' ').map! { |num| num.to_i }
    @compareguess = @guess.dup
    execute
  end

  #let the computer make random codes
  def com_make_code
    @rand_code = 4.times.map { [1,2,3,4,5,6].sample }
    @compare = @rand_code.dup
    @code_made = true
  end

  #the structure for computer guessing
  def com_guess_structure
    #left and right part of the game
    @left_part = []
    @right_part = []
    #keep black & white pegs for each round 
    @black_pegs = []
    @white_pegs = []
  end

  #let computer initially guess 5 times to determine the positions of numbers
  def com_guess
    com_guess_structure
    #guess like this every single game
    @initial_guess_list = [[1,1,2,2],[1,1,3,3],[1,1,4,4],[1,1,5,5],[1,1,6,6]]
    #check if this initial list matches with the random code
    @initial_guess_list.each do |guess|
      @guess = guess
      @compareguess = @guess.dup
      execute
      #put the pegs into the array to keep track of number positions
      @black_pegs << @black_peg
      @white_pegs << @white_peg
    end
    com_guess_analyze
    execute
    while @game_over == false
      swap_values
      execute
    end
  end

  #combines all the methods required to analyze the code pattern
  def com_guess_analyze
    #subtract pegs for one
    if one_left_right?(@black_pegs, @left_part)
      @black_pegs = subtract_one(@black_pegs, @ones)
    end
    if one_left_right?(@white_pegs, @right_part)
      @white_pegs = subtract_one(@white_pegs, @ones)
    end
    left_right?
    if @left_part.size < 2
      fill_duplicate_value(@left_part)
    elsif @right_part.size < 2
      fill_duplicate_value(@right_part)
    end
    @guess = @left_part + @right_part
  end

  #remove the pegs that implies that '1' exists
  def subtract_one(peg_type, number_of_one)
    peg_type.map { |x| x - number_of_one }
  end

  #check if number 1 is on the left or right and push it to the correct side
  def one_left_right?(peg_type, part)
    if peg_type.all? { |peg| peg >= 1 }
      if peg_type.all? { |peg| peg >= 2 }
        part.push(1,1)
        @ones = 2
      else
        part.push(1)
        @ones = 1
      end
      true
    else 
      false
    end
  end

  #swap the values of 2 array items
  def swap(first, second)
    @guess[first], @guess[second] = @guess[second], @guess[first]
  end

  #swap values if the result still doesn't match the code
  def swap_values
    #if already swapped and still not correct, swap the other part, reverse the previous one
    if @swapped == true && @black_peg == 2
      swap(0,1)
      swap(2,3)
    #swap only two numbers if there are already 2 blacks
    elsif @black_peg == 2
      swap(0,1)
      @swapped = true
    end
    #swap left and right if there are no black pegs (meaning all pos. are wrong)
    if @black_peg == 0
      swap(0,1)
      swap(2,3)
    end
  end

  # fill dup if there are more than 2 of the numbers (ex. 5 5 5 1)
  def fill_duplicate_value(side)
    #join left and right to a single array
    left_and_right = @left_part + @right_part
    #fill that value if there are 2 of them already
    value_to_fill = left_and_right.detect { |dup| left_and_right.count(dup) > 1 }
    if side.size == 0
      side << value_to_fill << value_to_fill
    elsif side.size == 1
      side << value_to_fill
    end
  end

  #push the value to left or right accordingly to their quantity (num is qty)
  def left_right?
    # (i+2) here represents the actual code number itself ex. 0+2 = 2 then fill number 21
    @black_pegs.each_with_index do |num, i|
      @right_part.fill(i+2, @right_part.size, num) if num != 0
    end
    @white_pegs.each_with_index do |num, i|
      @left_part.fill(i+2, @left_part.size, num)  if num != 0
    end
  end

  def game_over?
    if @guess == @rand_code
      puts @guesser.capitalize + ' Wins!, the secret code is ' + @rand_code.to_s
      puts 'It takes ' + @round_counter.to_s + ' rounds to win'
      @game_over = true
      reset
    elsif @round_counter >= 12
      puts 'You Lose!, the secret code is ' + @rand_code.to_s 
      @game_over = true
      reset
    else
      @game_over = false
    end
  end

  def execute
    puts 'Guess value = ' + @guess.to_s
    if @code_made != true
      com_make_code
    end
    @black_peg = 0
    @white_peg = 0
    game_over?
    if @game_over != true
      exact?
      exist?
    end
    @compare = @rand_code.dup
    @round_counter += 1
  end

  #find out how many black pegs there are
  def exact?
    @rand_code.each_with_index do |num, i|
      if @rand_code[i] == @guess[i]
        @compare[i] = 'x'
        @compareguess[i] = 'x'
        @black_peg += 1
      end
    end
    @compare.delete('x')
    @compareguess.delete('x')
    puts 'Black Pegs: ' + @black_peg.to_s
  end

  #find out how many white pegs there are
  def exist?
    #return intersection with duplicate values allowed
    @intersect = (@compare & @compareguess).flat_map do |n| 
      [n] * [@compare.count(n), @compareguess.count(n)].min 
    end
    @white_peg = @intersect.size
    puts 'White Pegs: ' + @white_peg.to_s
  end

  def play_again?
    puts 'Play Again? (y/n)'
    playagain = gets.chomp.downcase
    if playagain == 'y'; choose_player;
    elsif playagain == 'n'; exit;
    else; puts 'INVALID INPUT' end
  end

  def reset
    @game_over = false
    @round_counter = 1
    @code_made = false
    @swapped = false
    play_again?
  end
end

Mastermind.new