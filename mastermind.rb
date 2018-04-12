class Mastermind
  attr_accessor :guess

  @@randnum = 4.times.map { [1,2,3,4,5,6].sample }
  @@compare = @@randnum.dup

  def initialize
    @black_peg = 0
    @white_peg = 0
  end

  def execute
    @@compareguess = @guess.dup
    @black_peg = 0
    @white_peg = 0
    exact?
    exist?
  end

  def exact?
    @@randnum.each_with_index do |num, i|
      if num == guess[i]
        @@compare.delete(num)
        @@compareguess.delete(num)
        @black_peg += 1
      end
    end
    puts 'Exact Position: ' + @black_peg.to_s
  end

  def exist?
    @@compare.each_index do |index|
      if @@compare.include? @@compareguess[index]
        @white_peg += 1
      end
    end
    puts 'Right Color: ' + @white_peg.to_s
  end
end

mygame = Mastermind.new