//
//  main.swift
//  Day 03
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

extension Array where Element: MutableCollection, Element.Index == Int {
    subscript(_ position: (x: Int, y: Int)) -> Element.Element? {
        get { self[position.x, position.y] }
        set { self[position.x, position.y] = newValue! }
    }

    subscript(_ x: Int, _ y: Int) -> Element.Element? {
        get { self[y][x] }
        set { self[y][x] = newValue! }
    }

    // this assumes the array is 2D with same-size rows
    var width: Int { self[0].count }
    var height: Int { count }
}

func + (lhs: (x: Int, y: Int), rhs: (x: Int, y: Int)) -> (x: Int, y: Int) {
    (lhs.x + rhs.x, lhs.y + rhs.y)
}

func += (lhs: inout (x: Int, y: Int), rhs: (x: Int, y: Int)) {
    lhs = lhs + rhs
}

// MARK: - Part 1

enum Part1 {
    static let slope = (x: 3, y: 1)

    static func run(_ map: [[String]]) {
        var position = (x: 0, y: 0)
        var trees = 0

        while position.y < map.height {
            trees += map[position] == "#" ? 1 : 0
            position += slope
            position.x %= map.width // wrap around (e.g. duplicate map to the right of current map)
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
    static let slopes = [
        (x: 1, y: 1),
        (x: 3, y: 1),
        (x: 5, y: 1),
        (x: 7, y: 1),
        (x: 1, y: 2),
    ]

    static func run(_ map: [[String]], with slope: (x: Int, y: Int)) -> Int {
        var position = (x: 0, y: 0)
        var trees = 0

        while position.y < map.height {
            trees += map[position] == "#" ? 1 : 0
            position += slope
            position.x %= map.width // wrap around (e.g. duplicate map to the right of current map)
        }

        return trees
    }

    static func run(_ map: [[String]]) {
        let product = slopes
            .map { run(map, with: $0) }
            .reduce(1, *)

        print("Part 2:")
        print("Answer is \(product)")
    }
}

//Part2.run(InputData.example)
Part2.run(InputData.challenge)
