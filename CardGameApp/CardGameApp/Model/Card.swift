//
//  Card.swift
//  CardGame
//
//  Created by joon-ho kil on 5/21/19.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

class Card: ShowableToImage {
    // nested Suit enumeration
    enum Suit: Character, CaseIterable {
        case spades = "♠️", hearts = "♥️", diamonds = "♦️", clubs = "♣️"
    
        func getPoint () -> Int {
            switch self {
            case .clubs: return 4
            case .diamonds: return 3
            case .hearts: return 2
            case .spades: return 1
            }
        }
        
        func getCode () -> String {
            switch self {
            case .clubs: return "c"
            case .diamonds: return "d"
            case .hearts: return "h"
            case .spades: return "s"
            }
        }
    }
    
    // nested Rank enumeration
    enum Rank: Int, CaseIterable {
        case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
        
        func getCode () -> String {
            switch self {
            case .ace: return "A"
            case .jack: return "J"
            case .king: return "K"
            case .queen: return "Q"
            default: return String(self.rawValue)
            }
        }
    }
    
    // Card properties and methods
    private var rank: Rank, suit: Suit, back: Bool
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
        self.back = true
    }
    
    func isEqualToRank (_ card: Card) -> Bool {
        return rank == card.rank
    }
    
    func isNextRankThan (_ card: Card) -> Bool {
        if rank == .two && card.rank == Rank.ace {
            return true
        }
        
        return rank == Rank(rawValue: card.rank.rawValue + 1)
    }
    
    func isHigherThan (_ card: Card) -> Bool {
        let rankPoint = rank.rawValue == 1 ? 13 : rank.rawValue
        let cardRankPoint = card.rank.rawValue == 1 ? 13 : card.rank.rawValue
        
        if rankPoint > cardRankPoint {
            return true
        }
        
        if rankPoint < cardRankPoint {
            return false
        }
        
        if suit.getPoint() > card.suit.getPoint() {
            return true
        }
        
        return false
    }
    
    private func getImageName() -> String {
        let suitCode = suit.getCode()
        let rankCode = rank.getCode()
        let imageName = suitCode+rankCode+".png"
        
        return imageName
    }
    
    func flip() {
        back = !back
    }
}

extension Card: CustomStringConvertible {
    var description: String {
        switch(rank.rawValue) {
        case 1: return "\(suit.rawValue)A"
        case 11: return "\(suit.rawValue)J"
        case 12: return "\(suit.rawValue)Q"
        case 13: return "\(suit.rawValue)K"
        default: return "\(suit.rawValue)\(rank.rawValue)"
        }
    }
    
    func showToImage(handler: (String) -> ()) {
        if back {
            handler("card-back.png")
            return
        }
        
        let name = getImageName()
        handler(name)
    }
}