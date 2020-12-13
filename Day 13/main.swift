//
//  main.swift
//  Day 13
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 13:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let timestamp = Int(input[0])!
        let busIDs = input[1].components(separatedBy: ",").compactMap(Int.init)

        print("Part 1 (\(source)):")
        for time in timestamp... {
            for id in busIDs {
                if time % id == 0 {
                    let delay = time - timestamp
                    print("Bus ID \(id) leaves in \(delay) minutes for a product of \(id * delay)")
                    return
                }
            }
        }
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
