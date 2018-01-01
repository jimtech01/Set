//
//  ViewController.swift
//  Set
//
//  Created by Jim Dresher on 11/29/17.
//  Copyright © 2017 Jim Dresher. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
  
// MARK: Variables
    
    var game = SetModel()
    
    var buttonForCard = [Int : Card]()  // store 'card' for button 'Int' in dictionary
    
    var buttonsInUse = [Int]()          // track buttons used
    
    var threeCards = [(Int, Card)]()    // three cards selected with deal-three, may be different
    
    var score = 0  // game score
        
    
    var nextCard = Card()
    
    var matchFound = false
    var noMatch = false
    
    var setsFound = [[(Int, Card)]]()
    
// MARK:  Constants
    
    struct Constants {
        static let maxButtons = 24
        static let dealThree = 3
        static let deck = 81
        static let startDeal = 12
        static let blank = ""
    }
    
    struct Colors {
        static let red = UIColor.red
        static let green = UIColor.green
        static let blue = UIColor.blue
        static let orange = UIColor.orange
        static let black = UIColor.black
        static let white = UIColor.white
        static let yellow = UIColor.yellow
    }
    
    struct Symbol {
        static let circle = "●"
        static let square = "■"
        static let triangle = "▲"
        static let unknown = "?"
        static let blank = ""
    }
    
// MARK: Outlets
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "Score : \(score)"
        }
    }
    
    @IBOutlet weak var dealButton: UIButton!     // button to deal three 'new cards', disabled if no space for cards
    
    @IBOutlet weak var messageLabel: UILabel! {  // messages for game situations
        didSet {
            messageLabel.text = ""
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {                           // start game when view is set
            setupGame()
        }
    }
    
// MARK: Actions
    
    @IBAction func newGame()
    {
        game.reset()
        print("\n***   New Game   ***\n")
        setupGame()
        score = 0
    }
    
    func checkEndOfGame()
    {
        if game.playingCards.count < 81 {
            printStatus()
        } else {
            var cardsInPlay = [Card]()
            let sortedButtons = buttonForCard.keys.sorted()
            for index in sortedButtons {
                if let card = buttonForCard[index] { cardsInPlay.append(card) }
            }
            let setsFound = findSets(cards: cardsInPlay)
            if setsFound.count > 0 {
                messageLabel.text = "\(setsFound.count) sets available in current cards. "
            } else { messageLabel.text = "Game Over! Click 'New Game'"}
            print("sets found in current cards: \(setsFound.count)")
            for set in setsFound {
                print("Set:")
                for card in set {
                    print("card traits: \(card.traits)")
                }
            }
            printStatus()
        }
    }
    
    func printStatus()
    {
        print("\n***   Game State  ***")
        print("cards used: \(game.playingCards.count), sets: \(score / 3), buttons in use: \(buttonForCard.count)\n")
        let sortedButtons = buttonForCard.keys.sorted()
        for index in sortedButtons {
            if let ident = buttonForCard[index]?.identifier, let traits = buttonForCard[index]?.traits {
                print("card \(ident), traits: \(traits) at button: \(index)")
            }
        }
        print("***\n")
    }
    
    
    func findNeeds(card1: Card, card2: Card) -> [Int]
    {            // find needed traits to match two chosen cards
        let traits1 = card1.traits
        let traits2 = card2.traits
        let num0 = 3 - (traits1[0] + traits2[0])%3     // 1+1, 1+2, 1+3, 2+1, 2+2, 2+3, 3+1, 3+2, 3+3 -> 2, 3, 4, 5, 6 %3 -> 2, 0, 1, 2, 0
        let num1 = 3 - (traits1[1] + traits2[1])%3     // switch on mod3 of two traits to get need
        let num2 = 3 - (traits1[2] + traits2[2])%3     // 0 needs 3, 1 needs 2, 2 needs 1
        let num3 = 3 - (traits1[3] + traits2[3])%3     //
        return [num0, num1, num2, num3]
    }
    
    func findCard(with needs: [Int], in cards: [Card]) -> Card?
    {              // find a card with 'needs' in group of cards
        for index in cards {
            if intsEqual(a1: needs, a2: index.traits) { return index }
        }
        return nil
    }
    
    func intsEqual(a1: [Int], a2: [Int]) -> Bool
    {
        return (a1[0] == a2[0] && a1[1] == a2[1] && a1[2] == a2[2] && a1[3] == a2[3]) ? true : false
    }
    
    
    func findSets(cards: [Card]) -> [[Card]]  // find possible sets in cards-displayed (or any group of cards)
    {
        var matchedCards = [Card]()
        let count = cards.count-1
        var setFound = [[Card]]()
        for index1 in 0...count-1 {
            for index2 in 1...count-2 {
                let card1 = cards[index1]
                let card2 = cards[index2]
                let needs = findNeeds(card1: card1, card2: card2)
                
                if let found = findCard(with: needs, in: cards),
                    (!matchedCards.contains(card1) || !matchedCards.contains(card2) || !matchedCards.contains(found)),
                    (card1 != card2 && card1 != found && card2 != found) {
                    setFound.append([card1, card2, found])
                    matchedCards.append(card1)
                    matchedCards.append(card2)
                    matchedCards.append(found)
                }
            }
        }
        return setFound
    }
    
    @IBAction func dealThree()  // should call model when cards are needed, disable button when 'not available'
    {                           // test for buttons available. If match replace 'set' with 'threeNewCards'.
                                // if 'match', replace 'threeCards' with new cards
        if game.playingCards.count < Constants.deck {    //  when == 81 go to end of game checking
            switch matchFound {
            case true:
                finishMatch()
                matchFound = false
            case false:
                if buttonForCard.count <= Constants.maxButtons - Constants.dealThree {  // check for room on playing board
                    dealButton.isEnabled = true
                    let threeNewCards = game.dealThree()
                    if !threeNewCards.isEmpty {
                        //  print("three cards received from model: \(threeNewCards)")
                        let someButtons = selectButtons(howMany: Constants.dealThree, outOf: Constants.maxButtons, using: buttonsInUse)
                        if !someButtons.isEmpty {
                            for index in someButtons.indices {
                                let button = someButtons[index]
                                let card = threeNewCards[index]
                                buttonForCard[button] = card
                                displayACard(which: card, atButton: button)
                            }
                        }
                    } else { print(" no cards available to be dealt"); dealButton.isEnabled = false }
                } else { print(" no room for cards on playing board"); dealButton.isEnabled = false }
            }
        } else {
            dealButton.isEnabled = false
          //  checkEndOfGame()
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton)
    {
        if let button = cardButtons.index(of: sender), let card = buttonForCard[button] {
            let message = game.chooseCard(card: card)  // call model with card touched
            switch message.0 {
            case "card selected":
                if matchFound { finishMatch(); matchFound = false }
                if noMatch { finishNoMatch(); noMatch = false }
                threeCards.append((button, card))
                showSelected(index: button)
            case "delete first":
                let tuple = threeCards.removeFirst()
                deselect(card: tuple.0)
            case "delete last":
                let tuple = threeCards.removeLast()
                deselect(card: tuple.0)
            case "match":
                showSelected(index: button)
                threeCards.append((button, card))
                showASet(cards: threeCards)
                score += 3
                matchFound = true
            case "no match":
                threeCards.append((button,card))
                showNoMatch(cards: threeCards)
                noMatch = true
            default: print("other message received: '\(message.0)', cards: \(message.1)")
            }
        }
    }
    
// MARK: Methods
    
    func setupGame()     // should call model to get cards
    {
        for i in 0..<cardButtons.count {  // set cardButtons to facedown
            cardButtons[i].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cardButtons[i].setTitle(nil, for: .normal)
            cardButtons[i].setAttributedTitle(nil, for: .normal)
            cardButtons[i].layer.borderWidth = 0.0
            cardButtons[i].layer.borderColor = UIColor.orange.cgColor
            cardButtons[i].layer.cornerRadius = 0.0
        }
        buttonForCard = [:]   // empty dictionary
        buttonsInUse = []
        let someCards = game.getSomeCards(howMany: Constants.startDeal)  // get 12 starting cards
        let someButtons = selectButtons(howMany: Constants.startDeal, outOf: Constants.maxButtons, using: buttonsInUse) // find 12 buttons to locate cards
        for index in someButtons.indices {
            let button = someButtons[index]
            let card = someCards[index]
            buttonForCard[button] = card
        }
        updatViewFromModel()
        if dealButton != nil { dealButton.isEnabled = true }
        score = 0
       // scoreLabel.text = "Score: \(score)"
    }
    
    func selectButtons(howMany: Int, outOf: Int, using buttons: [Int]) -> [Int]
    {
        if howMany <= 24 - buttons.count {  // test for more buttons than available
            var indexes = [Int]()
            for i in 0...(outOf - 1) { indexes.append(i) }
            var picked = [Int]()
            
            while picked.count < howMany {
                let randomIndex = Int(arc4random_uniform(UInt32(indexes.count)))
                let selection = indexes[randomIndex]
                if !picked.contains(selection), !buttonsInUse.contains(selection) {
                    picked.append(selection)
                    buttonsInUse.append(selection)
                }
            }
            return picked
        } else { return [] }
    }
    
    func updatViewFromModel()  // loop through cardButtons and update each with 'new card' info
    {
        for index in cardButtons.indices {
            let _ = cardButtons[index]
            if let card = buttonForCard[index] {
                displayACard(which: card, atButton: index)
            } // else { print(" bad mojo") }
        }
    }
    
    func finishMatch()
    {               // called if match is found and another card is selected
                    // check for empty return from getSomCards(...)
                    // 'hide' threeCards buttons if empty return
        if game.playingCards.count <= 78 {
            let newCards = game.getSomeCards(howMany: 3)
            for index in threeCards.indices {
                let button = threeCards[index].0
                let newCard = newCards[index]
                buttonForCard[button] = newCard
                deselect(card: button)
                displayACard(which: newCard, atButton: button)
            }
        } else {
            hideCards(cards: threeCards)
            checkEndOfGame()
        }
        threeCards = []
        scoreLabel.text = "Score : \(score)"
    }
    
    func finishNoMatch()
    {
        for (index,_) in threeCards {
            deselect(card: index)
        }
        threeCards = []
    }
    
    func gameOver()
    {
        
    }
    
    func displayACard(which card: Card, atButton index: Int)
    {                                               // make all the strings attributed ✓
        // cardTraits = (num,col,shape,shade)
        let symbolType = card.traits[2]
        let symbolCount = card.traits[0]
        let cardColor = card.traits[1]
        let shading = card.traits[3]
        var symbol = Symbol.blank
        var showSymbol = Symbol.blank
        var symbolColor = Colors.yellow
        switch symbolType {
        case 1: symbol = Symbol.circle
        case 2: symbol = Symbol.square
        case 3: symbol = Symbol.triangle
        default: symbol = Symbol.unknown
        }
        switch symbolCount {
        case 1: showSymbol = symbol
        case 2: showSymbol = symbol + symbol
        case 3: showSymbol = symbol + symbol + symbol
        default: showSymbol = Symbol.unknown
        }
        switch cardColor {
        case 1: symbolColor = Colors.red
        case 2: symbolColor = Colors.green
        case 3: symbolColor = Colors.blue
        default: symbolColor = Colors.yellow
        }
        switch shading {
        case 1:  // solid
            let attShowSymbol = NSAttributedString(string: showSymbol, attributes: [ .foregroundColor : symbolColor, .strokeWidth : -1.0])
            cardButtons[index].setAttributedTitle(attShowSymbol, for: .normal)
        case 2:  // outline
            let attShowSymbol = NSAttributedString(string: showSymbol, attributes: [ .foregroundColor : symbolColor, .strokeWidth : 3.0])
            cardButtons[index].setAttributedTitle(attShowSymbol, for: .normal)
        case 3:  // shaded
            let attShowSymbol = NSAttributedString(string: showSymbol, attributes: [ .foregroundColor : symbolColor.withAlphaComponent(0.3), .strokeWidth : -1.0])
            cardButtons[index].setAttributedTitle(attShowSymbol, for: .normal)
        default:  // match background 'orange'
            cardButtons[index].setTitleColor(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), for: .normal)
            cardButtons[index].setTitle( nil, for: .normal)
        }
        cardButtons[index].backgroundColor = UIColor.white
    }
    
    func hideCards(cards: [(Int, Card)])
    {
        for (index,_) in threeCards {
            cardButtons[index].setAttributedTitle(nil, for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            deselect(card: index)
            buttonForCard[index] = nil
        }
    }
    
    func showSelected(index: Int)
    {
        cardButtons[index].layer.borderWidth = 3.0
        cardButtons[index].layer.borderColor = Colors.green.cgColor
        cardButtons[index].layer.cornerRadius = 8.0
    }
    
    func showASet(cards: [(Int, Card)])
    {
        for (index, _) in cards {
            cardButtons[index].layer.borderWidth = 3.0
            cardButtons[index].layer.borderColor = Colors.red.cgColor
            cardButtons[index].layer.cornerRadius = 8.0
        }
    }
    
    func showNoMatch(cards: [(Int, Card)])
    {
        for (index, _) in cards {
            cardButtons[index].layer.borderWidth = 3.0
            cardButtons[index].layer.borderColor = Colors.black.cgColor
            cardButtons[index].layer.cornerRadius = 8.0
        }
    }
    
    func deselect(card at: Int)
    {
        cardButtons[at].layer.borderWidth = 0.0
        cardButtons[at].layer.borderColor = Colors.orange.cgColor
        cardButtons[at].layer.cornerRadius = 0.0
    }
    
} // end of Class ViewController





