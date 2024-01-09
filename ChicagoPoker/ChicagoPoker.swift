//
//  File.swift
//  ChicagoPoker
//
//  Created by John Binzer on 1/8/24.
//

import Foundation

struct ChicagoPoker<CardContent> {
    private(set) var deck = Deck()
    var players: Array<Player> = []
    
    init(numPlayers: Int) {
        for playerId in 0..<numPlayers {
            players.append(Player(id: playerId))
        }
    }
    
    mutating func initialDeal() {
        // deal out 7 cards to each player
        for _ in 0..<7 {
            for idx in players.indices {
                players[idx].hand.append(deck.deal())
            }
        }
    }
    
    mutating func redraw(playerId: Int, cards: Array<Card>) {
        for cardIndex in cards.indices {
            for handIndex in players[playerId].hand.indices {
                if cards[cardIndex] == players[playerId].hand[handIndex] {
                    players[playerId].hand[handIndex] = deck.deal()
                }
            }
        }
    }
    
    func scorePokerHand(hand: Array<Card>) -> Int {
        // assumes the hand is sorted by rank
        var counts: [Card.Rank: Int] = [:]
        var isFlush = false
        var isStraight = false
        
        for card in hand {
            // check if hand is a flush
            if card.suit != hand[0].suit {
                isFlush = false
            } else {
                isFlush = true
            }
            
            // count up pairs/trips/quads
            if counts.keys.contains(card.rank) {
                counts[card.rank]! += 1
            } else {
                counts[card.rank] = 1
            }
            
            //check for straight
            isStraight = false
        }

        if isFlush && isStraight && hand[0].rank == Card.Rank.r10 {
            return 52 //royal
        } else if isFlush && isStraight {
            return 8
        } else if counts.values.contains(4) {
            return 7
        } else if counts.values.contains(3) && counts.values.contains(2) {
            return 6
        } else if isFlush {
            return 5
        } else if isStraight {
            return 4
        } else if counts.values.contains(3) {
            return 3
        } else if counts.values.contains(2) && counts.count == 3 {
            return 2
        } else if counts.values.contains(2) {
            return 1
        } else {
            return 0
        }
    }
    
    
    struct Player: Identifiable {
        // let username: String
        let id: Int
        var score: Int = 0
        var isPlayerTurn = false
        var hand: Array<Card> = []
    }
    
    struct Card: Identifiable, Equatable{
        var isFaceUp = true
        let rank: Rank
        let suit: Suit
        var id: String {"\(rank.description)\(suit.description)"}
        
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.rank == rhs.rank && lhs.suit == rhs.suit
        }
        
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
}

