//
//  main.swift
//  Day 03
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
    static let slope = (x: 3, y: 1)

    static func run(_ map: [[String]]) {
        var position = (x: 0, y: 0)
        var trees = 0

        while position.y < map.count {
            if map[position.y][position.x] == "#" {
                trees += 1
            }
            position.x = (position.x + slope.x) % map[position.y].count
            position.y += slope.y
        }
        print("Part 1:")
        print("End position: \(position). Encountered \(trees) trees.")
    }
}

//Part1.run(InputData.example)
Part1.run(InputData.challenge)

// MARK: - Part 2

print("")

enum Part2 {
    static func run() {
        print("Part 2:")
    }
}

//Part2.run()
