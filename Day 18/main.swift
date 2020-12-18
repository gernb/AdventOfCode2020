//
//  main.swift
//  Day 18
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 18:")

enum Part1 {
    static func solve(_ line: String) -> (answer: Int, remainder: String) {
        var acc = 0
        var operation: ((Int, Int) -> Int)?
        var remainder = line
        while !remainder.isEmpty {
            let next = String(remainder.removeFirst())
            switch next {
            case "+":
                operation = { $0 + $1 }
            case "*":
                operation = { $0 * $1 }
            case "(":
                let (result, nextRemainder) = solve(remainder)
                remainder = nextRemainder
                if let operation = operation {
                    acc = operation(acc, result)
                } else {
                    acc = result
                }
            case ")":
                return (acc, remainder)
            case " ":
                break
            default:
                let number = Int(next)!
//                assert(remainder.isEmpty || remainder.first == " ")
                if let operation = operation {
                    acc = operation(acc, number)
                } else {
                    acc = number
                }
            }
        }
        return (acc, remainder)
    }

    static func run(_ source: InputData) {
        let input = source.data
        var sum = 0

        for var line in input {
            var result = 0
            repeat {
                let (partial, remainder) = solve(line)
                result += partial
                line = remainder
            } while !line.isEmpty
            if source != .challenge {
                print(result)
            }
            sum += result
        }

        print("Part 1 (\(source)) sum: \(sum)")
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
