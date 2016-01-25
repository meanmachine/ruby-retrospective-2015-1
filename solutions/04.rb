class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def to_s
    "#{rank.to_s.capitalize} of #{suit.capitalize}"
  end

  def ==(card)
    @rank == card.rank and @suit == card.suit
  end
end

class Deck
  include Enumerable

  SUITS = [:spades, :hearts, :diamonds, :clubs]

  attr_reader :deck

  def initialize(deck)
    @deck = deck
    @top_card, @bottom_card = deck.first, deck.last
  end

  def size()
    @deck.size
  end

  def draw_top_card()
    @deck.shift
  end

  def draw_bottom_card()
    @deck.pop
  end

  def top_card()
    @deck.first
  end

  def bottom_card()
    @deck.last
  end

  alias play_card draw_top_card

  def shuffle()
    @deck.shuffle!
  end

  def sort(ranks = RANKS)
    @deck.sort! do |left_card, right_card|
      case SUITS.index(right_card.suit) <=> SUITS.index(left_card.suit)
        when -1 then  1
        when  1 then -1
        when  0
          (ranks.index(right_card.rank) <=> ranks.index(left_card.rank))
      end
    end
  end

  def each()
    @deck.each { |card| yield card }
  end

  def to_s()
    @deck.map(&:to_s)
  end

  def deal(cards_count)
    @deck.shift cards_count
  end
end

module Deal
  def allow_face_up?
    size <= 3
  end

  def highest_of_suit(suit)
    sort.select { |card| card.suit == suit }.first
  end

  def kings_and_queens()
    select { |card| [:king, :queen].include? card.rank }.group_by(&:suit)
  end

  def belote?()
    kings_and_queens.values.any? { |suit| suit.size == 2 }
  end

  def sequence?(count)
    sort.group_by(&:suit).values.any? do |suit|
      suit.map(&:rank).each_cons(count).any? do |con|
        BeloteDeck::RANKS.each_cons(count).to_a.include? con.reverse
      end
    end
  end

  def carre?(rank)
    select { |card| card.rank == rank }.count == 4
  end

  def tierce?
    sequence? 3
  end

  def quarte?
    sequence? 4
  end

  def quint?
    sequence? 5
  end

  def carre_of_jacks?
    carre?(:jack)
  end

  def carre_of_nines?
    carre?(9)
  end

  def carre_of_aces?
    carre?(:ace)
  end

  def twenty?(trump_suit)
    cards = kings_and_queens
    cards.delete(trump_suit)
    cards.values.any? { |suit| suit.size == 2 }
  end

  def forty?(trump_suit)
    return false if not kings_and_queens[trump_suit]
    kings_and_queens[trump_suit].size == 2
  end
end

class WarDeck < Deck
  include Deal

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  DECK  = RANKS.product(SUITS).map{ |card| Card.new(*card) }

  def initialize(deck = DECK)
    super
  end

  def sort()
    super RANKS
  end

  def deal()
    WarDeck.new (super 26).to_a
  end
end

class BeloteDeck < Deck
  include Deal

  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]
  DECK  = RANKS.product(SUITS).map{ |card| Card.new(*card) }

  def initialize(deck = DECK)
    super
  end

  def sort()
    super RANKS
  end

  def deal()
    BeloteDeck.new (super 8).to_a
  end

end

class SixtySixDeck < Deck
  include Deal

  RANKS = [9, :jack, :queen, :king, 10, :ace]
  DECK  = RANKS.product(SUITS).map{ |card| Card.new(*card) }

  def initialize(deck = DECK)
    super
  end

  def sort()
    super RANKS
  end

  def deal()
    SixtySixDeck.new (super 6).to_a
  end
end