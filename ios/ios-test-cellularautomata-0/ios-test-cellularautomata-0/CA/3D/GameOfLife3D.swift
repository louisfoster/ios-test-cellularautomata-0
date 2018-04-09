//
//  GameOfLife3D.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation

/*
 1d array of width (x) and height (y) and depth (z)
 all cells to be iterated
 states of cell 0 or 1
 initial state (rand)
 neighbours: surrounding 6 cells
  - North (+1y)
  - East (-1x)
  - South (-1y)
  - West (+1x)
  - Front (+1z)
  - Back (-1z)
 rules:
 - death: state 1, overpop (3+ neighbours alive): 0, lonely (0 neighbours alive): 0
 - birth: state 0, 2 alive neighbours: 1
 - statis: !death && !birth
 */

protocol GameOfLife3DProtocol {
    
    var cells: [UInt8] { get set }
    var width: Int { get }
    var height: Int { get }
    var depth: Int { get }
    var initialAlive: Int { get }
    var initialIndices: [Int] { get set }
}

extension GameOfLife3DProtocol {
    
    mutating func setup() {
        
        if self.initialIndices.count == 0 {
            
            for _ in 0..<self.initialAlive {
                
                let point = Int(arc4random_uniform(UInt32(self.width * self.height * self.depth)))
                self.initialIndices.append(point)
            }
        }
        
        for d in 0..<self.depth {
        
            for h in 0..<self.height {
                
                for w in 0..<self.width {
                    
                    let index = self.getIndex(section: d, row: h, column: w)
                    
                    if self.initialIndices.contains(index) {
                        
                        self.cells.append(UInt8(1))
                    }
                    else {
                        
                        self.cells.append(UInt8(0))
                    }
                }
            }
        }
    }
    
    func getIndex(section: Int, row: Int, column: Int) -> Int {
        
        // equal to first row, first column of section (0, 0, section)
        let sectionOrigin = section * self.height * self.width
        
        let rowOrigin = sectionOrigin + (row * self.width)
        
        return rowOrigin + column
    }
    
    public mutating func updateStates(completion: (_: [UInt8]) -> Void) {
        
        var newStates = [UInt8]()
        
        for section in 0..<self.depth {
        
            for row in 0..<self.height {
                
                for column in 0..<self.width {
                    
                    let currentIndex = getIndex(section: section, row: row, column: column)
                    
                    // same section, next row, same column (row = last, then 0)
                    let north = self.getIndex(section: section,
                                              row: (row == self.height - 1) ? 0 : row + 1,
                                              column: column)
                    // same section, same row, next column (column = last, then 0)
                    let east = self.getIndex(section: section,
                                             row: row,
                                             column: (column == self.width - 1) ? 0 : column + 1)
                    // same section, previous row, same column (row = first, then row count - 1)
                    let south = self.getIndex(section: section,
                                              row: (row == 0) ? self.height - 1 : row - 1,
                                              column: column)
                    // same section, same row, previous column (column = first, then column count - 1)
                    let west = self.getIndex(section: section,
                                             row: row,
                                             column: (column == 0) ? self.width - 1 : column - 1)
                    // next section, same row, same column (section = last, then 0)
                    let front = self.getIndex(section: (section == self.depth - 1) ? 0 : section + 1,
                                              row: row,
                                              column: column)
                    // previous section, same row, same column (section = first, then section count - 1)
                    let back = self.getIndex(section: (section == 0) ? self.depth - 1 : section - 1,
                                             row: row,
                                             column: column)
                    
                    var neighbours = [UInt8]()
                    
                    neighbours.append(self.cells[north])
                    neighbours.append(self.cells[east])
                    neighbours.append(self.cells[south])
                    neighbours.append(self.cells[west])
                    neighbours.append(self.cells[front])
                    neighbours.append(self.cells[back])
                    
                    let newState = self.getNewState(neighbours: neighbours, state: self.cells[currentIndex])
                    
                    newStates.append(newState)
                }
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
        else if state == 0 && alive == 2 {
            
            return 1
        }
        else {
            
            return state
        }
    }
}

struct GameOfLife3D: GameOfLife3DProtocol {
    
    var initialAlive: Int
    var initialIndices: [Int]
    var cells: [UInt8]
    var width: Int
    var height: Int
    var depth: Int
    
    init(width: Int, height: Int, depth: Int, initial: [Int]? = nil) {
        
        self.width = width
        self.height = height
        self.depth = depth
        self.cells = [UInt8]()
        self.initialAlive = Int(arc4random_uniform(UInt32(self.width * self.depth)) + 1)
        
        if let i = initial, i.count != 0 {
            
            self.initialIndices = i
        }
        else {
            
            self.initialIndices = [Int]()
        }
        
        self.setup()
    }
}
