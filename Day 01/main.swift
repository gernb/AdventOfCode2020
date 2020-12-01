//
//  main.swift
//  Day 01
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

extension Collection {
    func combinations(of size: Int) -> [[Element]] {
        func pick(_ count: Int, from: ArraySlice<Element>) -> [[Element]] {
            guard count > 0 else { return [] }
            guard count < from.count else { return [Array(from)] }
            if count == 1 {
                return from.map { [$0] }
            } else {
                return from.dropLast(count - 1)
                    .enumerated()
                    .flatMap { pair in
                        return pick(count - 1, from: from.dropFirst(pair.offset + 1)).map { [pair.element] + $0 }
                    }
            }
        }

        return pick(size, from: ArraySlice(self))
    }
}

// MARK: - Part 1

enum Part1 {
    static func run(_ input: [Int]) {
        print("Part 1:")
        for pair in input.combinations(of: 2) {
            if pair[0] + pair[1] == 2020 {
                print("\(pair[0]) * \(pair[1]) = \(pair[0] * pair[1])")
                break
            }
        }
    }
}

//Part1.run(InputData.example)
Part1.run(InputData.challenge)

// MARK: - Part 2

enum Part2 {
    static func run(_ input: [Int]) {
        print("\nPart 2:")
        for tuple in input.combinations(of: 3) {
            if tuple[0] + tuple[1] + tuple[2] == 2020 {
                print("\(tuple[0]) * \(tuple[1]) * \(tuple[2]) = \(tuple[0] * tuple[1] * tuple[2])")
                break
            }
        }
    }
}

//Part2.run(InputData.example)
Part2.run(InputData.challenge)
