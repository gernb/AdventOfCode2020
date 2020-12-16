//
//  main.swift
//  Day 16
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

struct Rule {
    let field: String
    let range1: ClosedRange<Int>
    let range2: ClosedRange<Int>

    init(_ line: String) {
        let parts = line.components(separatedBy: ": ")
        self.field = parts[0]
        let ranges = parts[1].components(separatedBy: " ")
        let range1 = ranges[0].components(separatedBy: "-")
        self.range1 = Int(range1[0])! ... Int(range1[1])!
        let range2 = ranges[2].components(separatedBy: "-")
        self.range2 = Int(range2[0])! ... Int(range2[1])!
    }

    func valid(_ value: Int) -> Bool {
        return range1.contains(value) || range2.contains(value)
    }
}

// MARK: - Part 1

print("Day 16:")

enum Part1 {
    static func invalidFields(for ticket: [Int], with rules: [Rule]) -> [Int] {
        return ticket.compactMap { field in
            for rule in rules {
                if rule.valid(field) {
                    return nil
                }
            }
            return field
        }
    }

    static func run(_ source: InputData) {
        let input = source.data
        let rules = input[0].components(separatedBy: .newlines).map(Rule.init)
        let tickets = input[2]
            .components(separatedBy: .newlines)
            .dropFirst()
            .map { $0.components(separatedBy: ",").compactMap(Int.init) }

        let errors = tickets.map { invalidFields(for: $0, with: rules) }.flatMap { $0 }
        print("Part 1 (\(source)) error rate: \(errors.reduce(0, +))")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Rule: Hashable {}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data
        let rules = input[0].components(separatedBy: .newlines).map(Rule.init)
        let tickets = input[2]
            .components(separatedBy: .newlines)
            .dropFirst()
            .map { $0.components(separatedBy: ",").compactMap(Int.init) }
        let myTicket = input[1]
            .components(separatedBy: .newlines)
            .dropFirst()
            .map { $0.components(separatedBy: ",").compactMap(Int.init) }
            .first!

        let validTickets = tickets.compactMap { ticket in
            Part1.invalidFields(for: ticket, with: rules).isEmpty ? ticket : nil
        }
        let fields = Set(rules.map(\.field))
        var columns = Array(repeating: fields, count: myTicket.count)

        validTickets.forEach { ticket in
            ticket.enumerated().forEach { idx, field in
                rules.forEach { rule in
                    if !rule.valid(field) {
                        columns[idx].remove(rule.field)
                    }
                }
            }
        }

        while !columns.allSatisfy({ $0.count == 1 }) {
            columns.filter({ $0.count == 1 }).forEach { column in
                let field = column.first!
                for i in columns.indices {
                    if columns[i].count > 1 {
                        columns[i].remove(field)
                    }
                }
            }
        }

        let product = columns.enumerated()
            .filter({ $1.first!.hasPrefix("departure") })
            .reduce(1) { result, pair in
                result * myTicket[pair.offset]
            }

        print("Part 2 (\(source)) product: \(product)")
        print(columns)
        print(myTicket)
    }
}

InputData.allCases.forEach(Part2.run)
