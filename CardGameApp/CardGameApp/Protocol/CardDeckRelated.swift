//
//  CardDeckRelated.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/23/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

protocol ShowableToCardDeck {
    func showToOneCard(handler: (String) -> ()) throws
    func refreshCardDeck()
    func moveToPointStack() -> Int?
    func moveToCardStack() -> Int?
    func count() -> Int
}
