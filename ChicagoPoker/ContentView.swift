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
    
    var description: String {
        rank.description + suit.description
    }
}

class Deck {
    var cards: [Card] = Card.Suit.allCases
        .map { suit in
            Card.Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }
        .flatMap { $0 }
    
    func deal() -> Card {
        return self.cards.removeFirst()
    }
}

struct ContentView: View {
    @State var deck: Deck = Deck()
    var flopIsVisible: Bool = false
    
    var body: some View {
        VStack {
            Text("Flop")
            HStack{
                CardView(card: deck.deal())
                CardView(card: deck.deal())
                CardView(card: deck.deal())
            }
            Text("Hand")
            HStack {
                CardView(card: deck.deal())
                CardView(card: deck.deal())
            }
            Text("Deck: \(deck.cards.count)")
            Text("first card: \(deck.cards[0].description)")
            Button("Shuffle") {
                deck.cards.shuffle()
            }
        }
        .padding()
    }
}

struct CardView: View {
    var card: Card
    var isFaceUp: Bool = true
    var body: some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(card.suit == Card.Suit.clubs ? .gray: .yellow)
                Text("\(card.description)")
            } else {
                RoundedRectangle(cornerRadius: 15).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    ContentView()
}
