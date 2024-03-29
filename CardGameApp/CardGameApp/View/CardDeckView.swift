//
//  CardDeckView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/20/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class CardDeckView: UIView {
    var backCardView = UIView()
    var refreshView = UIView()
    var openCards = [UIImageView]()
    
    func showCardBack() {
        let image: UIImage = UIImage(named: ImageFileName.cardBack.rawValue) ?? UIImage()
        backCardView = UIImageView(image: image)
        backCardView.frame = CGRect(x: 350, y: 20, width: 50, height: 63)
        self.addSubview(backCardView)
    }
    
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        openCards = [UIImageView]()
    }
    
    func removeCardDeck() {
        for view in openCards {
            view.removeFromSuperview()
        }
    }
    
    func showCard(_ card: ShowableToCardDeck) {
        do {
            var imageView = UIImageView()
            
            try card.showToOneCard(handler: { (cardImageName) in
                let coordinateX = Double(295)
                let coordinateY = Double(20)
                
                let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
                imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 62)
                self.addSubview(imageView)
                openCards.append(imageView)
            })
            
            while true {
                if let point = card.moveToPointStack() {
                    UIImageView.animate(withDuration: 0.15, animations: {
                        self.openCards.last?.frame = CGRect(x: 20 + 55 * point, y: 20, width: 50, height: 63)
                    }, completion: { (finished: Bool) in
                        self.openCards.removeLast()
                    })
                } else {
                    break
                }
            }
            
            if card.count() == 0 {
                backCardView.removeFromSuperview()
                showRefresh()
            }
            
        } catch {
            card.refreshCardDeck()
            removeCardDeck()
            removeRefresh()
            showCardBack()
        }
    }
    
    private func showRefresh() {
        let image: UIImage = UIImage(named: ImageFileName.refresh.rawValue) ?? UIImage()
        refreshView = UIImageView(image: image)
        refreshView.frame = CGRect(x: 366, y: 36, width: 30, height: 30)
        self.addSubview(refreshView)
    }
    
    private func removeRefresh() {
        backCardView.removeFromSuperview()
        refreshView.removeFromSuperview()
    }
    
    func moveToCardStack(_ card: ShowableToCardDeck & ShowableToCardStack) -> (UIImageView?, Int) {
        guard let column = card.moveToCardStack() else {
            return (nil, -1)
        }
        
        let row = card.getCardStackRow(column: column)
        
        guard let cardView = openCards.last else {
            return (nil, -1)
        }
        
        openCards.removeLast()
        
        UIImageView.animate(withDuration: 0.15, animations: {
            cardView.frame = CGRect(x: 20 + 55 * column, y: 100 + 20 * (row - 1), width: 50, height: 63)
        })
        
        return (cardView, column)
    }
}
