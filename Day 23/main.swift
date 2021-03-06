//
//  main.swift
//  Day 23
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 23:")

enum Part1 {
    static func run(_ source: InputData) {
        var input = source.data
        var cup = input.first!

        for _ in 1...100 {
            let idx = input.firstIndex(of: cup)!

            let idxRemoveFirst = (idx + 1) % input.count
            let removeFirst = input[idxRemoveFirst]

            let idxRemoveSecond = (idx + 2) % input.count
            let removeSecond = input[idxRemoveSecond]

            let idxRemoveThird = (idx + 3) % input.count
            let removeThird = input[idxRemoveThird]

            let nextCupIdx = (idx + 4) % input.count
            let nextCup = input[nextCupIdx]

            let removed = [removeFirst, removeSecond, removeThird]
            let idxRemoved = [idxRemoveThird, idxRemoveSecond, idxRemoveFirst].sorted(by: >)
            input.remove(at: idxRemoved[0])
            input.remove(at: idxRemoved[1])
            input.remove(at: idxRemoved[2])

            var destination = cup
            var destinationIdx: Int?
            repeat {
                destination = destination - 1
                if destination == 0 { destination = input.count + 3 }
                destinationIdx = input.firstIndex(of: destination)
            } while destinationIdx == nil

            input.insert(contentsOf: removed, at: destinationIdx! + 1)
            cup = nextCup
        }

        let doubled = input + input
        let first1 = doubled.firstIndex(of: 1)!
        let last1 = doubled.lastIndex(of: 1)!
        let answer = doubled[first1 + 1 ..< last1].map(String.init).joined()

        print("Part 1 (\(source)): \(answer)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        var circle: [Int: Int] = [:]
        for (idx, n) in input.dropLast().enumerated() {
            circle[n] = input[idx + 1]
        }
        var current = input.last!
        for n in 10...1_000_000 {
            circle[current] = n
            current = n
        }
        circle[current] = input.first!
        current = input.first!

        for _ in 1...10_000_000 {
            let pickup = [
                circle[current]!,
                circle[circle[current]!]!,
                circle[circle[circle[current]!]!]!
            ]
            let next = circle[pickup.last!]!
            circle[current] = next

            var destination = current
            repeat {
                destination = destination - 1
                if destination == 0 { destination = 1_000_000 }
            } while pickup.contains(destination)

            circle[pickup.last!] = circle[destination]
            circle[destination] = pickup.first!

            current = next
        }

        let label1 = circle[1]!
        let label2 = circle[label1]!
        print("Part 2 (\(source)): \(label1) * \(label2) = \(label1 * label2)")
    }
}

InputData.allCases.forEach(Part2.run)
