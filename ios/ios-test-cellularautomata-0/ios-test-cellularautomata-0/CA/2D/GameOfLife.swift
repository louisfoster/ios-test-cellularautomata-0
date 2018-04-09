//
//  GameOfLife.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation

/*
 1d array of width and height
 all cells to be iterated
 states of cell 0 or 1
 initial state (rand)
 neighbours: surrounding 8 cells
 rules:
 - death: state 1, overpop (4+ neighbours alive): 0, lonely (<2 neighbours alive): 0
 - birth: state 0, 3 alive neighbours: 1
 - statis: !death && !birth
*/

protocol GameOfLifeProtocol {
    
    var cells: [UInt8] { get set }
    var width: Int { get }
    var height: Int { get }
    var initialAlive: Int { get }
    var initialIndices: [Int] { get set }
}

extension GameOfLifeProtocol {
    
    mutating func setup() {
        
        if self.initialIndices.count == 0 {
            
            for _ in 0..<self.initialAlive {
                
                let point = Int(arc4random_uniform(UInt32(self.width * self.height)))
                self.initialIndices.append(point)
            }
        }
        
        for row in 0..<self.height {
            
            for column in 0..<self.width {
                
                let index = row * self.width + column
                if self.initialIndices.contains(index) {
                    
                    self.cells.append(UInt8(1))
                }
                else {
                    
                    self.cells.append(UInt8(0))
                }
            }
        }
    }
    
    public mutating func updateStates(completion: (_: [UInt8]) -> Void) {
        
        var newStates = [UInt8]()
        
        for row in 0..<self.height {
            
            for column in 0..<self.width {
                
                let rPrev = row == 0 ? self.height - 1 : row - 1
                let rNext = row == self.height - 1 ? 0 : row + 1
                let cPrev = column == 0 ? self.width - 1 : column - 1
                let cNext = column == self.width - 1 ? 0 : column + 1
                
                var neighbours = [UInt8]()
                
                let currentIndex = row * self.width + column
                neighbours.append(self.cells[rPrev * self.width + cPrev])
                neighbours.append(self.cells[rPrev * self.width + column])
                neighbours.append(self.cells[rPrev * self.width + cNext])
                neighbours.append(self.cells[row * self.width + cPrev])
                neighbours.append(self.cells[row * self.width + cNext])
                neighbours.append(self.cells[rNext * self.width + cPrev])
                neighbours.append(self.cells[rNext * self.width + column])
                neighbours.append(self.cells[rNext * self.width + cNext])
                
                let newState = self.getNewState(neighbours: neighbours, state: self.cells[currentIndex])
                
                newStates.append(newState)
            }
        }
        
        self.cells = newStates
        
        completion(self.cells)
    }
    
    func getNewState(neighbours: [UInt8], state: UInt8) -> UInt8 {
        
        let alive = neighbours.reduce(0, { x, y in
            x + y
        })
        
        if state == 1 && alive >= 4 || alive < 2 {
            
            return 0
        }
        else if state == 0 && alive == 3 {
            
            return 1
        }
        else {
            
            return state
        }
    }
}

struct GameOfLife: GameOfLifeProtocol {
    
    var initialAlive: Int
    var initialIndices: [Int]
    var cells: [UInt8]
    var width: Int
    var height: Int
    
    init(width: Int, height: Int, initial: [Int]? = nil) {
        
        self.width = width
        self.height = height
        self.cells = [UInt8]()
        self.initialAlive = Int(arc4random_uniform(UInt32(self.width * 2)) + 1)
        
        if let i = initial, i.count != 0 {
            
            self.initialIndices = i
        }
        else {
        
            self.initialIndices = [Int]()
        }
        
        self.setup()
    }
}
