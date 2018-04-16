class Mastermind

  def initialize
    @round_counter = 0
    @black_peg = 0
    @white_peg = 0
    @code_made = false
  end

  def com_make_code
    @rand_code = 4.times.map { ['1','2','3','4','5','6'].sample }
    @compare = @rand_code.dup
    @code_made = true
  end

  def guesss
    @guess = gets.chomp.split(' ')
    @compareguess = @guess.dup
    execute
  end

  def game_over?
    if @guess == @rand_code
      puts 'You Win!, the secret code is ' + @rand_code.to_s
    elsif @round_counter == 11
      puts 'You Lose!, the secret code is ' + @rand_code.to_s 
    end
  end

  def execute
    if @code_made != true
      com_make_code
    end
    @black_peg = 0
    @white_peg = 0
    game_over?
    exact?
    exist?
    @compare = @rand_code.dup
    @round_counter += 1
  end

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
    puts 'Exact Position: ' + @black_peg.to_s
  end

  def exist?
    @intersect = @compare & @compareguess
    @white_peg = @intersect.size
    puts 'Right Color: ' + @white_peg.to_s
  end
end

mygame = Mastermind.new