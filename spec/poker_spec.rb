require 'poker.rb'

describe "Poker" do
  describe "Card" do
    subject(:card) { Card.new("diamond", "8")}
    subject(:default_card) { Card.new }

    describe "#initialize" do
      it "should pass a value and suit" do
        expect(card.suit).to eq("diamond")
        expect(card.value).to eq("8")
      end

      it "should have a default value and suit" do
        expect(default_card.suit).to eq("default_suit")
        expect(default_card.value).to eq("default_value")
      end
    end

    describe "#value and #suit" do
      it "should expose its value instance variable" do
        expect(card.instance_variable_get(:@value)).to eq(card.value)
        expect(card.instance_variable_get(:@suit)).to eq(card.suit)
      end
    end
  end

  describe "Deck" do
    subject(:deck) { Deck.new }

    subject(:card_array) do
      card_array = []

      Card.suits.each do |suit|
        Card.value.each do |value|
          card_array << Card.new(suit,value)
        end
      end

      card_array
    end

    let(:draw_one) {deck.draw(1)}
    let(:over_draw) {deck.draw(53)}

    describe "#initialize" do
      it "should have 52 cards" do
        expect(deck.count).to eq(52)
      end

      it "should be an array of Cards" do
        expect(deck.cards.class).to be(Array)
        expect(deck.cards[0].class).to be(Card)
      end

      it "generates all 52 cards" do
        expect(deck.cards).to eq(card_array)
      end
    end

    describe "#draw" do
      it "should draw 1 card" do
        expect(draw_one.class).to be(Array)
        expect(draw_one.count).to eq(1)
        expect(deck.cards.count).to eq(51)
      end

      it "cannot overdraw" do
        expect {over_draw}.to raise_error "Insufficient cards in deck!"
      end
    end

    let(:deck1) {Deck.new}
    let(:deck2) {Deck.new}

    before do
      deck1.shuffle
      deck2.shuffle
    end
    describe "#shuffle" do
      it "deck should be random" do
        expect(deck1.cards).not_to eq(deck2.cards)
      end
    end

    let(:duplicate_card) { [Card.new("hearts", "5")] }



    describe "#return" do
      let(:drawed_card)  {deck.draw(1)}
      let(:drawed_card1)  {deck1.draw(1)}

      it "should return cards to the deck" do
        deck.return_card(drawed_card)
        expect(deck.count).to eq(52)
        expect([deck.cards[-1]]).to eq(drawed_card)
      end

      it "raises an error if we have more than 52 cards in a deck" do
        expect {deck.return_card(drawed_card1)}.to raise_error "More than 52 cards in deck."
      end

      it "raise an error if we return a duplicate card to the deck" do
        deck.draw(1)
        expect {deck.return_card(duplicate_card)}.to raise_error "Duplicate card returned to deck"
      end

      it "raise an error if we're not returning an array of cards" do
        deck.draw(1)
        expect {deck.return_card(5)}.to raise_error "Not an array of cards!"
      end

    end

  end


  describe "Hand" do
    let(:hand) {Hand.new}
    describe "#initialize" do
      it "Should expose cards" do
        expect(hand.instance_variable_get(:@cards)).to eq(hand.cards)
      end
      it "initiates to an empty hand" do
        expect(hand.cards).to eq([nil, nil, nil, nil, nil])
      end
    end

    let(:deck) { double("deck", draw: [1,2,3,4,5,6,7,8,9,10])}
    let(:full_hand) {hand.draw(deck)}
    describe "#draw" do
      it "draws until 5 cards in hand" do
        hand.draw(deck)
        expect(hand.cards.count).to eq(5)
      end
    end

    describe "#discard" do
    subject(:hand_cards) { Hand.new([1, 2, 3, 4, 5])}
    let(:dummy_deck) { double("dummy_deck", return_card: nil)}
      it "discards specified cards" do
        test_hand.discard([0,1], dummy_deck)
        expect(test_hand.cards).to eq([nil,nil,Card.new("diamonds", "5"),
        Card.new("hearts", "7"),
        Card.new("clubs", "J")])

        expect(dummy_deck).to receive(:return_card)
      end
    end

    let(:test_hand) {Hand.new([Card.new("diamonds", "10"),
                              Card.new("spades", "5"),
                              Card.new("diamonds", "5"),
                              Card.new("hearts", "7"),
                              Card.new("clubs", "J")]) }


    describe "#suits" do
      it "returns a hash of each suit occurence" do
        expect(test_hand.suits).to eq( {"diamonds" => 2, "spades" => 1, "hearts" => 1, "clubs" => 1})
      end
    end

    describe "#values" do
      it "should return a hash of each value occurence" do
        expect(test_hand.values).to eq( {"5" => 2, "10" => 1, "7" => 1, "J" => 1})
      end
    end

    describe "#highest_card" do
      it "should return the highest card" do
        expect(single.highest_card).to eq("J")
        expect(pair.highest_card).to eq("5")
        expect(two_pair.highest_card).to eq("10")
        expect(triples.highest_card).to eq("5")
        expect(straight.highest_card).to eq("A")
        expect(flush.highest_card).to eq("J")
        expect(fullhouse.highest_card).to eq("10")
        expect(quads.highest_card).to eq("10")
        expect(royalstraight.highest_card).to eq("A")
      end
    end

    describe "#is_flush?" do
      it "true if flush" do
        expect(flush.is_flush?).to eq(true)
        expect(royalstraight.is_flush?).to eq(true)
      end

      it "false if not flush" do
        expect(single.is_flush?).to eq(false)
      end

    end

    describe "#is_straight?" do
      it "true if straight" do
        expect(straight.is_straight?).to eq(true)
        expect(royalstraight.is_straight?).to eq(true)
      end

      it "false if not straight" do
        expect(single.is_straight?).to eq(false)
        expect(quads.is_straight?).to eq(false)
      end
    end
    let(:single) {Hand.new([Card.new("diamonds", "10"),Card.new("spades", "5"),Card.new("diamonds", "6"),Card.new("hearts", "7"),Card.new("clubs", "J")])}
    let(:pair) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "5"), Card.new("diamonds", "5"), Card.new("hearts", "7"), Card.new("clubs", "J")])}
    let(:two_pair) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "5"), Card.new("diamonds", "5"), Card.new("hearts", "10"), Card.new("clubs", "J")])}
    let(:triples) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "5"), Card.new("diamonds", "5"), Card.new("hearts", "7"), Card.new("clubs", "5")])}
    let(:straight) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "J"), Card.new("diamonds", "Q"), Card.new("hearts", "K"), Card.new("clubs", "A")])}
    let(:flush) {Hand.new([Card.new("diamonds", "6"), Card.new("diamonds", "5"), Card.new("diamonds", "4"), Card.new("diamonds", "10"), Card.new("diamonds", "J")])}
    let(:fullhouse) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "5"), Card.new("diamonds", "5"), Card.new("diamonds", "10"), Card.new("diamonds", "10")])}
    let(:quads) {Hand.new([Card.new("diamonds", "10"), Card.new("spades", "10"), Card.new("diamonds", "10"), Card.new("diamonds", "10"), Card.new("diamonds", "J")])}
    let(:royalstraight) {Hand.new([Card.new("diamonds", "A"), Card.new("diamonds", "K"), Card.new("diamonds", "Q"), Card.new("diamonds", "J"), Card.new("diamonds", "10")])}

    describe "#points" do
      it "scores singles" do
        expect(single.points).to eq(11)
      end

      it "scores pairs" do
        expect(pair.points).to eq(105)
      end

      it "scores two pairs" do
        expect(two_pair.points).to eq(225)
      end

      it "scores triples" do
        expect(triples.points).to eq(305)
      end

      it "scores straights" do
        expect(straight.points).to eq(414)
      end

      it "scores flushes" do
        expect(flush.points).to eq(551)
      end

      it "scores full houses" do
        expect(fullhouse.points).to eq(610)
      end

      it "scores quadruples" do
        expect(quads.points).to eq(810)
      end

      it "scores royal straights" do
        expect(royalstraight.points).to eq(954)
      end
    end

  end

  describe "Player" do
    subject(:player) {Player.new}
    let(:single) {Hand.new([Card.new("diamonds", "10"),Card.new("spades", "5"),Card.new("diamonds", "6"),Card.new("hearts", "7"),Card.new("clubs", "J")])}
    let(:deck) { Deck.new }
    describe "#initialize" do
      it "reveal instance variable to hand" do
        expect(player.instance_variable_get(:@hand)).to eq(player.hand)
      end
      it "initiates with an empty hand class" do
        expect(player.hand.class).to eq(Hand)
        expect(player.hand.count).to eq(0)
      end

      it "initiates with a hand" do
        expect(Player.new(single).hand).to eq(single)
      end

    end


    describe "#draw_hand" do
    before do
      player.draw_hand(deck)
    end
      it "draws until hand is full" do
        expect(player.hand.count).to eq(5)
      end

      it "delegates to hand's draw method" do
        expect(player.hand).to receive(:draw)
      end
    end

    describe "#discard" do
      let(:player_single) {Player.new(single)}

      it "discard is delegated to the hand discard method" do
        expect(single).to receive(:discard)
        player_single.discard([0,1],deck)
      end

      it "discards cards from player hand" do
        player_single.discard([0,1],deck)
        expect(player_single.hand).to eq(Hand.new([nil,nil,Card.new("diamonds", "6"),Card.new("hearts", "7"),Card.new("clubs", "J")]))
      end
    end

  end

end
