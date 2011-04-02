
class LotteryTicket

  NUMERIC_RANGE = 1..25
  
  attr_reader :picks, :purchased

  def initialize(*picks)
    # Validate the picks the caller made.
    if picks.length != 3
      raise ArgumentError, "Three numbers must be picked!"
    elsif picks.uniq.length != 3
      raise ArgumentError, "The three picks must be different numbers!"
    elsif picks.detect { |p| not NUMERIC_RANGE === p }
      # Detects if a number is out of the acceptable range.
      raise ArgumentError, "The three picks must each be between 1 and 25."
    end
    @picks = picks
    @purchased = Time.now
  end

  def score(final)
    count = 0
    final.picks.each do |note|
      count += 1 if picks.include?(note)
    end
    count
  end

  def self.new_random
    new(rand(25) + 1, rand(25) + 1, rand(25) + 1)
  rescue ArgumentError
    redo
  end
end

class LotteryDraw
  @@tickets = {}

  def LotteryDraw.buy(customer, *tickets)
    @@tickets[customer] = [] unless @@tickets.has_key?(customer)
    @@tickets[customer] += tickets
  end

  def LotteryDraw.play
    final = LotteryTicket.new_random
    winners = {}
    @@tickets.each do |buyer, ticket_list|
      ticket_list.each do |ticket|
        score = ticket.score( final )
        next if score.zero?
        winners[buyer] ||= []
        winners[buyer] << [ ticket, score ]
      end
    end
    @@tickets.clear
    winners
  end
end



        
