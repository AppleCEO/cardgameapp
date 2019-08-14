//
//  CardView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

protocol CardStackDelegate {
    func doubleTapCard(column: Int, row: Int)
    func moveToPoint(column: Int, row: Int)
    func moveToStack(column: Int, row: Int, toColumn: Int) -> Bool
    func isMovableCard(column: Int, row: Int) -> Bool
}

class CardStackView: UIView {
    var stackView = Array(repeating: [UIImageView](), count: 7)
    var delegate: CardStackDelegate?
    var originCenter: CGPoint?
    
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        stackView = Array(repeating: [UIImageView](), count: 7)
    }
    
    func showCardStack(_ cardStack: ShowableToCardStack) {
        for column in 0..<7 {
            let maxRow = cardStack.getCardStackRow(column: column)
            
            for row in 0..<maxRow {
                showCard(cardStack, column, row)
            }
        }
    }

    func showCard(_ cardStack: ShowableToCardStack, _ column: Int, _ row: Int) {
        cardStack.showToCardStack(column, row, handler: { (cardImageName) in
            let coordinateX = 20 + 55 * column
            let coordinateY = 20 * row
        
            let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
            let imageView = UIImageView(image: image)
            
            imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 63)
            self.addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(draggingView))
            imageView.addGestureRecognizer(dragGesture)
            imageView.addGestureRecognizer(doubleTapGesture)
            
            stackView[column].append(imageView)
        })
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        var row = -1
        var column = -1
        
        for (i, stack) in stackView.enumerated() {
            if let j = stack.firstIndex(of: recognizer.view as! UIImageView) {
                column = i
                row = j
            }
        }
        
        if row >= 0 && column >= 0 {
            delegate?.doubleTapCard(column: column, row: row)
        }
    }
    
    func animateToPoint(_ column: Int, _ row: Int, _ pointIndex: Int) -> UIImageView? {
        var view: UIImageView?
        
        UIView.animate(withDuration: 0.15, animations: {
                    self.stackView[column][row].frame = CGRect(x: 20 + 55 * pointIndex, y: -80, width: 50, height: 63)
        })
        
        view = self.stackView[column][row]
        self.stackView[column][row].removeFromSuperview()
        self.stackView[column].remove(at: row)

        return view
    }
    
    func openLastCard(_ cardStack: ShowableToCardStack, _ column: Int, _ row: Int) {
        stackView[column].remove(at: row)
        showCard(cardStack, column, row)
    }
    
    func animateToStack(_ cardStack: ShowableToCardStack,_ column: Int, _ row: Int, _ moveColumn: Int) {
        let moveRow = stackView[moveColumn].count
        
        UIImageView.animate(withDuration: 0.15, animations: {
            self.stackView[column][row].frame = CGRect(x: 20 + 55 * moveColumn, y: 20 * moveRow, width: 50, height: 63)
        })
            
        self.showCard(cardStack, moveColumn, moveRow)
        self.stackView[column][row].removeFromSuperview()
        self.stackView[column].remove(at: row)
    }
    
    @objc func draggingView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        let draggedView = sender.view!
        var row = -1
        var column = -1
        
        if sender.state == .began {
           originCenter = draggedView.center
        }
        
        for (i, stack) in stackView.enumerated() {
            if let j = stack.firstIndex(of: draggedView as! UIImageView) {
                column = i
                row = j
            }
        }
        
        if delegate?.isMovableCard(column: column, row: row) ?? false {
            for index in row...stackView[column].count-1 {
                stackView[column][index].center = CGPoint(x: point.x, y: point.y+CGFloat(20*(index-row)))
            }
            
            if sender.state == .ended {
                if point.y <= 0 {
                    delegate?.moveToPoint(column: column, row: row)
                } else {
                    let toColumn: Int
                    switch point.x {
                    case 0 ... 20 + 55 * 1:
                        toColumn = 0
                    case 0 ... 20 + 55 * 2:
                        toColumn = 1
                    case 0 ... 20 + 55 * 3:
                        toColumn = 2
                    case 0 ... 20 + 55 * 4:
                        toColumn = 3
                    case 0 ... 20 + 55 * 5:
                        toColumn = 4
                    case 0 ... 20 + 55 * 6:
                        toColumn = 5
                    case 0 ... 20 + 55 * 7:
                        toColumn = 6
                    default:
                        toColumn = 7
                    }
                    
                    if !(delegate?.moveToStack(column: column, row: row, toColumn: toColumn))! {
                        draggedView.center = originCenter ?? CGPoint(x: 0, y: 0)
                    }
                }
            }
        }
    }
}
