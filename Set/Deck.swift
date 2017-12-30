//
//  SetGame.swift
//  SetGame
//
//  Created by Jim Dresher on 11/30/17.
//  Copyright © 2017 Jim Dresher. All rights reserved.
//

import Foundation

class SetGame
{
    var cards = [Card]()  // cards only contain identfier and empty traits array
    
    init()
    {   // makes 81 cards with correct values, //shuffled//
        for num in 1...3 {
            for col in 1...3 {
                for shape in 1...3 {
                    for shade in 1...3 {
                        var theCard = Card()
                        theCard.traits = [num, col, shape, shade]
                        cards.append(theCard)
                      //  print(theCard.description)
                    }
                }
            }
        }
       // cards.shuffle()  // shuffle the cards
    }

    var selectedCards = [Card]()
    
    var matchFound = false
    
    func chooseCard(card: Card) -> String  // send message back to controller
    {
      /*
        if matchFound {
            selectedCards = []
            selectedCards.append(card)
            matchFound = false
            return "get next"
        }
       */
       
        let cardCount = selectedCards.count
        switch cardCount {
        case 0:
            selectedCards.append(card)
            return "get next"
        case 1:
          //  print("case 1 of chooseCard\n\tcards: \(selectedCards)")
            if !selectedCards.contains(card) {
                selectedCards.append(card)
        //        print("append next card\n\t\(selectedCards)")
                return "get next"
            } else {
                return "deselect first card"
            }
        case 2:
        //    print("case 2 of chooseCard\n\tcards: \(selectedCards)")
            if !selectedCards.contains(card) {
                selectedCards.append(card)
                if isASet() {
        //            print("match found, cards:\n\t\(selectedCards)")
                    doMatchStuff()
                    return "match"
                } else { selectedCards = [] ; return "no match" }
            } else if let first = selectedCards.first , let last = selectedCards.last {
                if first == card {
                    selectedCards.removeFirst()
         //           print("first card removed")
         //           print("case 2 of chooseCard\n\tcards: \(selectedCards)")
                    return "deselect first card"
                } else {
                    if last == card {
                        selectedCards.removeLast()
          //              print("last card removed")
          //              print("case 2 of chooseCard\n\tcards: \(selectedCards)")
                        return "deselect last card"
                    }
                }
            }
            return "error"
            
        case 3:  // should never get here
         //   print("case 3 of chooseCard\n\t\(selectedCards)")
           // selectedCards.append(card)
           // print("append next card\n\t\(selectedCards)")
            if isASet() {
                return "match"
            } else { return "no match" } 
        default:
        //    print("case default of chooseCard")
            return "error"
        }
        
    }  // end of chooseCard(...)
   
    func doMatchStuff()
    {
        selectedCards = []
        matchFound = true
    }
    
    func doNoMatchStuff()
    {
        selectedCards = []
        matchFound = false
    }
   
    
    func isItASet(card1: Card, card2: Card, card3: Card) -> Bool  // this routine works!
    {
        let numberCount = card1.traits[0] + card2.traits[0] + card3.traits[0]
        let colorCount = card1.traits[1] + card2.traits[1] + card3.traits[1]
        let shapeCount = card1.traits[2] + card2.traits[2] + card3.traits[2]
        let shadingCount = card1.traits[3] + card2.traits[3] + card3.traits[3]
        
        if numberCount % 3 == 0 && colorCount % 3 == 0 && shapeCount % 3 == 0 && shadingCount % 3 == 0 {
         //   print("numberCount: \(numberCount)\ncolorCount: \(colorCount)\nshapeCount: \(shapeCount)\nshadingCount: \(shadingCount)\nThis is a set!")
            return true
        } else {
        //    print("numberCount: \(numberCount)\ncolorCount: \(colorCount)\nshapeCount: \(shapeCount)\nshadingCount: \(shadingCount)\nThis is not a set!")
            return false
        }
    }  // end of isItASet(...)


    func isASet() -> Bool
    {
        if selectedCards.count == 3 {
         //   print("three cards found")
        //    print(selectedCards)
            return isItASet(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2])
        } else { return false }
        
    }
    
} // end of Class SetGame


// func and extension for shuffling the deck
public func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}
extension Array {
    public mutating func shuffle() {
        for i in (1...count-1).reversed() {
            let j = random(i + 1)
            if i != j {
                let t = self[i]
                self[i] = self[j]
                self[j] = t
            }
        }
    }
}
