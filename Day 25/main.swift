//
//  main.swift
//  Day 25
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 25:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let card = input[0]
        let door = input[1]

        var cardLoopSize = 0
        var value = 1
        repeat {
            value = (value * 7) % 20201227
            cardLoopSize += 1
        } while value != card

        var doorLoopSize = 0
        value = 1
        repeat {
            value = (value * 7) % 20201227
            doorLoopSize += 1
        } while value != door

        value = 1
        for _ in 1...cardLoopSize {
            value = (value * door) % 20201227
        }
        let encryptionKey = value

        value = 1
        for _ in 1...doorLoopSize {
            value = (value * card) % 20201227
        }

        assert(encryptionKey == value)

        print("Part 1 (\(source)): \(encryptionKey)")
    }
}

InputData.allCases.forEach(Part1.run)
