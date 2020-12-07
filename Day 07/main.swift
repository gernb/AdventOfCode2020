//
//  main.swift
//  Day 07
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 7:")

final class Rule {
    let colour: String
    let contents: [(colour: String, count: Int)]

    /*
     vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
     bright white bags contain 1 shiny gold bag.
     faded blue bags contain no other bags.
     */
    init(string: String) {
        let parts = string.components(separatedBy: " bags contain ")
        self.colour = parts[0]
        if parts[1] == "no other bags." {
            self.contents = []
            return
        }
        let contains = parts[1].components(separatedBy: ", ")
        self.contents = contains.map { item in
            let words = item.components(separatedBy: " ")
            return ("\(words[1]) \(words[2])", Int(words[0])!)
        }
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let rules = input.map(Rule.init)

        var containedBy = [String: [String]]()
        rules.forEach { rule in
            rule.contents.forEach { colour, count in
                let inside = containedBy[colour, default: []]
                containedBy[colour] = inside + [rule.colour]
            }
        }

        print("Part 1 (\(source)):")

        var queue = containedBy["shiny gold"]!
        print("shiny gold bags can be contained inside \(queue)")

        var processedBags = Set<String>()
        var outermostBags = [String]()
        while !queue.isEmpty {
            let bag = queue.removeFirst()
            if rules.contains(where: { $0.colour == bag }) {
                outermostBags.append(bag)
            }
            for container in containedBy[bag, default: []] {
                if !processedBags.contains(container) && !queue.contains(container) {
                    queue.append(container)
                }
            }
            processedBags.insert(bag)
        }

        print("\(outermostBags.count) bags can contain a shiny gold bag.\n\(outermostBags)")
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
