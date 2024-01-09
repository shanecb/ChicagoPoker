//
//  ContentView.swift
//  ChicagoPoker
//
//  Created by Shane Bielefeld on 12/27/23.
//

import SwiftUI

struct Card: CustomStringConvertible {
    
    enum Suit: String, CaseIterable, CustomStringConvertible {
        case clubs = "♣️"
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♦️"
        
        var description: String {
            self.rawValue
        }
    }
    
    enum Rank: Int, CaseIterable, CustomStringConvertible {
        case r2
        case r3
        case r4
        case r5
        case r6
        case r7
        case r8
        case r9
        case r10
        case rJ
        case rQ
        case rK
        case rA
        
        var description: String {
            switch self {
            case .r2: "2"
            case .r3: "3"
            case .r4: "4"
            case .r5: "5"
            case .r6: "6"
            case .r7: "7"
            case .r8: "8"
            case .r9: "9"
            case .r10: "10"
            case .rJ: "J"
            case .rQ: "Q"
            case .rK: "K"
            case .rA: "A"
            }
        }
    }
    
    let rank: Rank
    let suit: Suit
    
    var isFaceUp = false
    var description: String {
        rank.description + suit.description
    }
    
}

struct Deck {
    var cards: [Card] = Card.Suit.allCases
        .map { suit in
            Card.Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }
        .flatMap { $0 }
    
    mutating func deal() -> Card {
        return self.cards.removeFirst()
    }
}

struct ContentView: View {
    @State var deck: Deck = Deck()
    @State var flop: Array<Card> = []
    @State var hand: Array<Card> = []
    
    var body: some View {
        VStack {
            flopView
            handView
            Text("Deck: \(deck.cards.count)")
            Text("first card: \(deck.cards[0].description)")
            deckToolbar
        }
        .padding()
    }
    
    var flopView: some View {
        VStack{
            Text("Flop")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 0)], spacing: 0) {
                ForEach(flop.indices, id: \.self) { index in
                    CardView(flop[index])
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                }
            }
        }
    }
    
    var handView: some View {
        VStack {
            Text("Hand")
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 0) {
                ForEach(hand.indices, id: \.self) { index in
                    CardView(hand[index])
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                }
            }
        }
    }
    
    var deckToolbar: some View {
        HStack {
            Button("Deal") {
                if flop.count < 3 {
                    flop.append(deck.deal())
                } else if hand.count < 2 {
                    hand.append(deck.deal())
                }
            }
            Spacer()
            Button("Shuffle") {
                deck.cards.shuffle()
            }
            Spacer()
            Button("Reset"){
                flop = []
                hand = []
            }
        }
    }
}

struct CardView: View {
    var card: Card
    
    init(_ card: Card) {
        self.card = card
    }

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            Group {
                base.foregroundColor(.white)
                base.strokeBorder(lineWidth: 4)
                Text(card.description)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

#Preview {
    ContentView()
}
