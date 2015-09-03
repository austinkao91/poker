class Card
  SUITS = {"clubs" => 20, "diamonds" => 40, "spades" => 60, "hearts" => 80}
  VALUE = {
    "A" => 14,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13
  }
  attr_reader :suit, :value

  def initialize(suit = "default_suit", value = "default_value" )
    @suit = suit
    @value = value
  end

  def self.suits
    SUITS.keys
  end

  def self.value
    VALUE.keys
  end

  def ==(card)
    if card.class == self.class
      card.suit == self.suit && card.value == self.value
    else
      false
    end
  end

  def self.points(key)
    VALUE[key]
  end

  def self.suit_points(key)
    SUITS[key]
  end

end

class Deck
  attr_reader :cards
  def initialize
    @cards = []
    Card.suits.each do |suit|
      Card.value.each do |value|
        @cards << Card.new(suit,value)
      end
    end
  end

  def count
    @cards.count
  end

  def shuffle
    @cards = @cards.shuffle
  end

  def [](idx)
    @cards[idx]
  end

  def ==(deck)
    if deck.class == self.class && deck.count == self.count
        (0..deck.count-1).all? do |idx|
          deck[idx] == self[idx]
        end
    else
      false
    end
  end

  def draw(num)
    if num > count
      raise "Insufficient cards in deck!"
    end
    card = @cards.take(num)
    @cards = @cards.drop(num)

    card
  end

  def return_card(cards)
    raise "Not an array of cards!" unless cards.class == Array || cards[0].class == Card
    raise "More than 52 cards in deck." if @cards.count >= 52
    raise "Duplicate card returned to deck" if cards.any? {|card| @cards.include?(card)}
    @cards += cards
  end
end

class Hand
  attr_reader :cards
  def initialize(cards = Array.new(5))
    @cards = cards
  end

  def draw(deck)
    @cards.each do |card|
      card ||= deck.draw(1)
    end
  end

  def discard(indices, deck)
    discarded_cards = []
    indices.each do |idx|
      discarded_cards << @cards[idx]
      @cards[idx] = nil
    end

    deck.return_cards(discarded_cards)
  end

  def suits
    suits = {}
    @cards.each do |card|
      if suits.key?(card.suit)
        suits[card.suit] += 1
      else
        suits[card.suit] = 1
      end
    end
    suits
  end

  def values
    values = Hash.new(0)
    @cards.each do |card|
      values[card.value] +=1
    end
    values
  end

  def points

  end

  def is_flush?
    suits.values.include?(5)
  end

  def is_straight?
    card_points = []
    values.keys.each do |card_value|
      card_points << Card.points(card_value)
    end
    card_points.sort!
    (0..card_points.count-2).all? do |idx|
      card_points[idx] + 1 == card_points[idx + 1]
    end
  end

  def highest_card
    high = 0
    card = ""
    p values
    values.each do |key, value|
      calc_point = Card.points(key) + 15 * value
      p calc_point
      if calc_point > high
        high = calc_point
        card = key
      end
    end
    card
  end

end
