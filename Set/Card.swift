//
//  Card.swift
//  Set
//
//  Created by Jim Dresher on 11/29/17.
//  Copyright © 2017 Jim Dresher. All rights reserved.
//

import Foundation


struct Card: Hashable, Equatable
{
    var hashValue: Int { return identifier}
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: Int
    var traits = [Int]()

    var description : String {
        get {
            return "ident: \(identifier), traits: \(traits)"
        }
    }
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int
    {
        identifierFactory += 1
        return identifierFactory
    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
