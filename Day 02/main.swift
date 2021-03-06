//
//  main.swift
//  Day 02
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct Policy {
    let letter: String
    let min: Int
    let max: Int

    init(_ string: String) {
        let tokens = string.components(separatedBy: " ")
        let values = tokens[0].components(separatedBy: "-").compactMap(Int.init)
        self.letter = tokens[1]
        self.min = values[0]
        self.max = values[1]
    }

    func isValid(_ password: String) -> Bool {
        let count = password.filter { String($0) == letter }.count
        return count >= min && count <= max
    }
}

enum Part1 {
    static func run(_ input: [[String]]) {
        let validCount = input.map { Policy($0[0]).isValid($0[1]) ? 1 : 0 }.reduce(0, +)
        print("Part 1:")
        print("\(validCount) valid passwords out of \(input.count)")
    }
}

//Part1.run(InputData.example)
Part1.run(InputData.challenge)

// MARK: - Part 2

print("")

struct NewPolicy {
    let letter: String
    let idx1: Int
    let idx2: Int

    init(_ string: String) {
        let tokens = string.components(separatedBy: " ")
        let values = tokens[0].components(separatedBy: "-").compactMap(Int.init)
        self.letter = tokens[1]
        self.idx1 = values[0] - 1
        self.idx2 = values[1] - 1
    }

    func isValid(_ password: String) -> Bool {
        let chars = password.map(String.init)
        let idx1Valid = chars[idx1] == letter
        let idx2Valid = chars[idx2] == letter
        return (idx1Valid || idx2Valid) && (idx1Valid != idx2Valid)
    }
}

enum Part2 {
    static func run(_ input: [[String]]) {
        let validCount = input.map { NewPolicy($0[0]).isValid($0[1]) ? 1 : 0 }.reduce(0, +)
        print("Part 2:")
        print("\(validCount) valid passwords out of \(input.count)")
    }
}

//Part2.run(InputData.example)
Part2.run(InputData.challenge)
