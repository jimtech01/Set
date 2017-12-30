//
//  Test.swift
//  Set
//
//  Created by Jim Dresher on 12/23/17.
//  Copyright © 2017 Jim Dresher. All rights reserved.
//

import Foundation
/*
 
 card 133, traits: [2, 3, 2, 3] at buton: 12
 card 140, traits: [3, 1, 2, 1] at buton: 17
 card 119, traits: [2, 2, 1, 1] at buton: 10
 card 154, traits: [3, 2, 3, 3] at buton: 14
 card 92, traits: [1, 2, 1, 1] at buton: 20
 card 110, traits: [2, 1, 1, 1] at buton: 23
 card 126, traits: [2, 2, 3, 2] at buton: 5
 card 91, traits: [1, 1, 3, 3] at buton: 7
 card 96, traits: [1, 2, 2, 2] at buton: 15
 card 142, traits: [3, 1, 2, 3] at buton: 3
 card 123, traits: [2, 2, 2, 2] at buton: 11
 card 144, traits: [3, 1, 3, 2] at buton: 13
 card 129, traits: [2, 3, 1, 2] at buton: 16
 card 125, traits: [2, 2, 3, 1] at buton: 0
 card 155, traits: [3, 3, 1, 1] at buton: 19
 card 97, traits: [1, 2, 2, 3] at buton: 22
 card 152, traits: [3, 2, 3, 1] at buton: 18
 card 156, traits: [3, 3, 1, 2] at buton: 2
 card 162, traits: [3, 3, 3, 2] at buton: 21
 card 160, traits: [3, 3, 2, 3] at buton: 4
 card 161, traits: [3, 3, 3, 1] at buton: 9
 card 138, traits: [3, 1, 1, 2] at buton: 6
 card 115, traits: [2, 1, 2, 3] at buton: 8
 card 94, traits: [1, 2, 1, 3] at buton: 1

 
 */
/*
 // setup game ✓
 // display cards at beginning ✓
 // allow user to touch up to three cards, test for match at three ✓
 // if match indicate it is a match, replace three selected cards, increment score ✓
 // if not a match indicate no match, allow three more selections ✓
 // deal three when 'new cards' are available and space available ✓
 // go until 'all cards' are used
 // allow a 'new game', start over with new card setup and continue ✓
 */
// test to see first and last card created
//    if let lastCard = game.deck.last, let firstCard = game.deck.first {
//        print("card[0]: \(firstCard)\ncard[max]: \(lastCard)")
//    }
/*     touchCard
 // touch on three cards with traits showing in display of 24 cards
 // test for 'set' on three cards, indicate a 'set' has been found
 // by display characteristic on all three cards, also message label?
 // if already selected card is touched again deselect that card
 // deselection only works for 1 or 2 cards not third
 // if 3 cards form a 'set', replace those 3 with 'new' cards from the deck
 // updateViewFromModel after each card is touched
 // viewController should call chooseCard() from Set game to update model
 // most of the logic of this func should be in chooseCard of Set game
 
 */
/*
 func findSomeSets()
 {
 var cardsShowing = [Card]()
 var buttonsShowing = [Int]()
 
 for (index, card) in buttonForCard {
 cardsShowing.append(card)
 buttonsShowing.append(index)
 }
 print("cards showing: \(cardsShowing.count), buttons showing: \(buttonsShowing.count)")
 func findSets(cards: [Card]) -> [[Int]]
 {
 var sets = [[Int]]()
 for indexOne in 0..<cards.count {
 for indexTwo in 1..<cards.count-1 {
 for indexThree in 2..<cards.count-2 {
 if game.isItASet(card1: cards[indexOne], card2: cards[indexTwo], card3: cards[indexThree]) {
 if cards[indexOne] != cards[indexTwo] && cards[indexTwo] != cards[indexThree] && cards[indexOne] != cards[indexThree] {
 sets.append([indexOne, indexTwo, indexThree])
 }
 }
 }
 }
 }
 return sets
 }
 
 func trimSets(setIn: [[Int]]) -> [[Int]]
 {
 var sortedGroup = [[Int]]()
 for item in setIn { sortedGroup.append(item.sorted()) }
 var strGroup = [String]()
 for item in sortedGroup {
 let str = String(describing: item)
 strGroup.append(str)
 }
 let newGroup = Array(Set(strGroup))
 let chars = CharacterSet.init(charactersIn: "[]")
 var retNewGroup = [[Int]]()
 for item in newGroup {
 var nums = [Int]()
 let trimstr = item.trimmingCharacters(in: chars).components(separatedBy: ", ")
 for i in trimstr {
 if let val = Int(i) {
 nums.append(val)
 }
 }
 retNewGroup.append(nums)
 }
 return retNewGroup
 }
 let found = findSets(cards: cardsShowing)
 let trimmedSets = trimSets(setIn: found)
 if !trimmedSets.isEmpty {
 print("found \(trimmedSets.count) sets in buttons\n\(trimmedSets)")
 } else { print("no sets available in buttons"); gameOver() }
 }
 */

/*
 if matchFound {
 threeCards.append((button, card))
 showSelected(index: button)
 matchFound = false
 return
 }
 switch message {
 case "get next":  //
 //     print("\(message) from chooseCard")
 if noMatch {
 for index in threeCards {
 deselect(card: index.0)
 }
 threeCards = []
 noMatch = false
 messageLabel.text = ""
 }
 if threeCards.count < 3 {
 threeCards.append((button, card))
 }
 showSelected(index: button)
 case "deselect first card":
 //     print("\(message) from chooseCard")
 if threeCards.count > 0 {
 let first = threeCards.removeFirst().0
 deselect(card: first)
 }
 // remove first card from selected cards
 case "deselect last card":
 //    print("\(message) from chooseCard")
 let last = threeCards.removeLast().0
 deselect(card: last)
 // remove last card from selected cards
 case "match":
 //    print("message from model: \(message) found")
 threeCards.append((button, card))
 //    print("threeCards:\t\(threeCards)")
 doMatchStuff()
 score += 3
 //   printStats()
 // do more stuff
 case "no match":
 print("message from model: \(message) found")
 threeCards.append((button, card))
 print("threeCards:\t\(threeCards)")
 doNoMatchStuff()
 // do more stuff
 default:
 print("\(message) encountered")
 }
 */

// select cards routines should be in model,  select random buttons should be in UI
/*     replaced by routines above and in model
 func getRandomCard() -> Card?
 {
 if cardChoices.count > 0 {
 let randomIndex = Int(arc4random_uniform(UInt32(cardChoices.count)))
 return cardChoices.remove(at: randomIndex)
 } else { return nil }
 }
 
 func selectCards(howMany: Int) -> [Card]
 {
 var selectedCards = [Card]()
 if howMany > 0 {
 for _ in 0...howMany-1 {
 if let card = getRandomCard() {
 selectedCards.append(card)
 } else { print("error no card available") }
 }
 } else { print(" desired cards must be greater than 0") }
 //  print("selected cards:\n\(selectedCards)")
 return selectedCards    // may increment cardsUsed here
 }
 
 func selectButtons(howMany: Int, outOf: Int, using dict: [Int : Card]) -> [Int]
 {
 var indexes = [Int]()
 for i in 0...(outOf - 1) { indexes.append(i) }
 var picked = [Int]()
 while picked.count < howMany {
 let randomIndex = Int(arc4random_uniform(UInt32(indexes.count)))
 let selection = indexes[randomIndex]
 if !picked.contains(selection), dict[selection] == nil {
 picked.append(selection)
 }
 }
 //  print("selected buttons:\n\(picked)")
 return picked    // may increment buttonsUsed here
 }
 
 func merge(selected cards: [Card], chosen buttons: [Int]) -> [Int : Card]
 {
 var buttonsDict = [Int : Card]()
 if !cards.isEmpty && !buttons.isEmpty {
 for i in 0...cards.count-1 {
 let index = buttons[i]
 buttonsDict[index] = cards[i]
 }
 }
 return buttonsDict
 }
 
 func combine(dict: [Int : Card], with: [Int : Card]) -> [Int : Card]
 {                                   // combine two dictionaries assuming no same keys
 var newDict = [Int : Card]()
 for key in dict { newDict[key.key] = key.value }
 for key in with { newDict[key.key] = key.value }
 return newDict
 }
 
 
 func showCards(howMany cards: Int, outOf: Int, howmany buttons: Int, using: [Int : Card]) -> [Int : Card]
 {
 if cards < buttons {  // return empty dictionary if desired cards greater than available buttons
 let deck = selectCards(howMany: cards)
 let displayButtons = selectButtons(howMany: cards, outOf: buttons, using: using)
 let dict = merge(selected: deck, chosen: displayButtons)
 let buttonsDict = combine(dict: using, with: dict)
 return buttonsDict
 } else { print("error, cards desired greater than available buttons"); return [:] }
 }
 // above routines in model
 
 */

