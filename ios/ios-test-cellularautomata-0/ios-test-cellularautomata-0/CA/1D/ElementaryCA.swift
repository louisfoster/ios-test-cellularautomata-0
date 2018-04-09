//
//  ElementaryCA.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 8/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation

/*
 
 TODO:
 
 States: 0, 2, 4 are "dead"
 State: 1, 3, 5 are "alive"
 
 These rules could be updated as so:
 1. If was dead (0) and is now alive, it is a baby (1)
 2. If was a baby (1) and is now dead, it is an angel (2)
 3. If was a baby (1) and is still alive, it is a person (3)
 4. If was an angel (2) and is now alive, it is a person (3)
 5. If was an angel (2) and is still dead, it is now dead (0)
 6. If was a person (3) and is now dead, it is a corpse (4)
 7. If was a corpse (4) and is now alive, it is a zombie (5)
 8. If was a corpse (4) and is still dead, it is now dead (0)
 9. If was a zombie (5) and is still alive, it is now a corpse (4)
 10. If was a zombie (5) and is now dead, it is now dead (0)
 
 */

struct Rules {
    
    static let Rule90: [UInt8] = [0, 1, 0, 1, 1, 0, 1, 0]
}

protocol ElementaryCAProtocol {
    
    var cells: [UInt8] { get set }
    var listOfCells: [UInt8] { get set }
    var width: Int { get }
    var height: Int { get }
}

extension ElementaryCAProtocol {
    
    mutating func setup() {
        
        for index in 0..<self.width {
            
            if index == Int(round(Double(self.width - 1) * 0.5)) {
                
                self.cells.append(1)
            }
            else {
                
                self.cells.append(0)
            }
        }
        
        let listLength = self.width * (self.height - 1)
        
        for _ in 0..<listLength {
            
            self.listOfCells.append(0)
        }
        
        for cell in self.cells {
            
            self.listOfCells.append(cell)
        }
    }
    
    mutating func updateStates(completion: (_: [UInt8]) -> Void) {
        
        var newCells: [UInt8] = []
        
        for index in 0..<self.cells.count {
            
            let limit = self.cells.count - 1
            let left: UInt8 = index == 0 ? self.cells[limit] : self.cells[index - 1]
            let right: UInt8 = index == limit ? self.cells[0] : self.cells[index + 1]
            
            let newCell = self.getNewState(left: left, center: self.cells[index], right: right, rule: Rules.Rule90)
            newCells.append(newCell)
        }
        
        self.cells = newCells
        
        let adjusted = self.listOfCells[self.width...]
        self.listOfCells = adjusted + self.cells

        completion(self.listOfCells)
    }
    
    func getNewState(left: UInt8, center: UInt8, right: UInt8, rule: [UInt8]) -> UInt8 {
        
        let value = (left, center, right)
        
        switch value {
            
        case (0, 0, 0):
            return rule[0]
        case (0, 0, 1):
            return rule[1]
        case (0, 1, 0):
            return rule[2]
        case (0, 1, 1):
            return rule[3]
        case (1, 0, 0):
            return rule[4]
        case (1, 0, 1):
            return rule[5]
        case (1, 1, 0):
            return rule[6]
        case (1, 1, 1):
            return rule[7]
        default:
            return center
        }
    }
}

struct ElementaryCA: ElementaryCAProtocol {
    
    // 1D array
    // States = 0 or 1
    // Neigbours = index - 1 or index + 1
    // Gen = state(t) = f(neighbour_states(t-1))
    
    // Rules = 000, 001, 010, 011, 100, 101, 110, 111
    //          0    1    0    1    1    0    1    0
    
    // Initial state: round(length of array / 2)
    
    // Fill image with array data
    
    var cells: [UInt8] = []
    var listOfCells: [UInt8] = []
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        self.setup()
    }
}
