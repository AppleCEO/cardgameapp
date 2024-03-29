//
//  CardDeck.swift
//  CardGame
//
//  Created by joon-ho kil on 5/21/19.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

class CardDeck {
    private var cards = [Card]()
    private var openCards = [Card]()
    
    init() {
        initCards()
        shuffle() 
    }
    
    /// 모든 카드 초기화
    private func initCards() {
        for suit in Card.Suit.allCases {
            initSuitCards(suit: suit)
        }
    }
    
    /// 모양 별 카드 초기화
    private func initSuitCards(suit: Card.Suit) {
        for rank in Card.Rank.allCases {
            cards.append(Card(rank: rank, suit: suit))
        }
    }
    
    /// 갖고 있는 카드 개수를 반환한다.
    func count() -> Int {
        return cards.count
    }
    
    /// 전체 카드를 랜덤하게 섞는다.
    func shuffle() {
        cards = cards.shuffled()
    }
    
    /// 카드 인스턴스 중에 하나를 반환하고 목록에서 삭제한다.
    func removeOne() throws -> Card {
        guard let firstCard = cards.first else {
            throw CardError.notExistCard
        }
        
        cards.removeFirst()
        
        return firstCard
    }
    
    /// 카드 중에 하나를 오픈한다.
    func openOne() throws -> Card {
        guard let firstCard = cards.first else {
            throw CardError.notExistCard
        }
        
        cards.removeFirst()
        openCards.append(firstCard)
        
        return firstCard
    }
    
    /// 오픈한 카드를 다시 뒤짚는다.
    func refresh() {
        cards = openCards
        
        for card in cards {
            card.flip()
        }
        
        openCards.removeAll()
    }
    
    /// 처음처럼 모든 카드를 다시 채워넣는다.
    func reset() {
        cards.removeAll()
        initCards()
    }
    
    /// 오픈한 카드 중 가장 위에 있는 카드를 리턴한다.
    func getOpenCard() -> Card? {
        return openCards.last
    }
    
    /// 오픈한 가장 위에 카드 제거한다.
    func removeOpenCard() {
        openCards.removeLast()
    }
    
    /// 열려있는 가장 위에 카드가 K 인지 확인한다.
    func isCardKAtOpenCardTop() -> Bool {
        return openCards.last?.isK() ?? false
    }
}
