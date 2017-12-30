//
//  SetModel.swift
//  Set
//
//  Created by Jim Dresher on 12/22/17.
//  Copyright © 2017 Jim Dresher. All rights reserved.
//

import Foundation

class SetModel
{
    var deck = [Card]()  // all cards to use in game 'a deck'

    var playingCards = [Card]()   // cards that have been dealt and cannot be used again
    
    var selectedCards = [Card]()  // array of cards selected by clicking in UI
    
    var possibleSet = [Card]()
    
    var matchFound = false
    
    init()
    {
        for num in 1...3 {
            for col in 1...3 {
                for shape in 1...3 {
                    for shade in 1...3 {
                        let traits = [num, col, shape, shade]
                        var card = Card()
                        card.traits = traits
                        deck.append(card)
                    }
                }
            }
        }
        playingCards = []
        selectedCards = []
        possibleSet = []
    }
    
    private func getRandomCard() -> Card
    {
        if playingCards.count < 81 {
            let index = Int(arc4random_uniform(UInt32(deck.count)))
            let card = deck[index]
            if  !playingCards.contains(card) {
                playingCards.append(card)
                return card
            } else {
                return getRandomCard()
            }
        } else {
            print("***in getRandomCard, no more cards available")
            return Card()
        }
    }
    
//  public API
    
    func getSomeCards(howMany: Int) -> [Card]
    {
        var morecards = [Card]()
        for _ in 0..<howMany { morecards.append(getRandomCard()) }
        print("--- in getSomeCards of model, playingcards used: \(playingCards.count)")
        return morecards
    }
    
    func chooseCard(card: Card) -> (String, [Card])  // may return more than just message
    {
        let selectedCount = selectedCards.count
        switch selectedCount {
        case 0:
            selectedCards.append(card)
            if matchFound { matchFound = false }
            return ("card selected", selectedCards)
        case 1:
            if selectedCards.first == card {  // pop first card, send 'delete first' message
                selectedCards.removeFirst()
                return ("delete first", selectedCards)
            } else {     // append card, send 'card selected' message
                selectedCards.append(card)
                return ("card selected", selectedCards)
            }
        case 2:
            if selectedCards.first == card {  // pop first card, send 'delete first' message
                selectedCards.removeFirst()
                return ("delete first", selectedCards)
            }
            if selectedCards.last == card {  // pop last card, send 'delete last' message
                selectedCards.removeLast()
                return ("delete last", selectedCards)
            } else {    // append card, test for 'set', send 'match' or 'no match' message
                selectedCards.append(card)
                let answer = isASet()
                if answer { matchFound = true } else { matchFound = false }
                possibleSet = selectedCards
                selectedCards = []
                return (answer ? "match" : "no match", possibleSet)
            }
        default: // should never reach this point
            return ("error in chooseCard of model", [])
        }
    }
    
    func dealThree() -> [Card]  // randomly select three cards from 'deck', return array of 'Card'
    {
        let howMany = 3
        if (howMany + playingCards.count) <= 81 {  // less than game.cards.count
           return getSomeCards(howMany: 3)
        } else { return [] }
    }
    
    func isASet() -> Bool
    {
        if selectedCards.count == 3 {
            return isItASet(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2])
        } else { return false }
    }
    
    func isItASet(card1: Card, card2: Card, card3: Card) -> Bool  // this routine works!
    {
        let numberCount = card1.traits[0] + card2.traits[0] + card3.traits[0]
        let colorCount = card1.traits[1] + card2.traits[1] + card3.traits[1]
        let shapeCount = card1.traits[2] + card2.traits[2] + card3.traits[2]
        let shadingCount = card1.traits[3] + card2.traits[3] + card3.traits[3]
        
        if numberCount%3 == 0 && colorCount%3 == 0 && shapeCount%3 == 0 && shadingCount%3 == 0 {
            return true
        } else { return false }
    }  // end of isItASet(...)
}
