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

Part1.run(.example)
Part1.run(.challenge)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data
        let rules = input.map(Rule.init).reduce(into: [String: Rule](), { $0[$1.colour] = $1 })

        print("Part 2 (\(source)):")

        var bagCount = 0
        var queue = [(rule: rules["shiny gold"]!, multiplier: 1)]
        while !queue.isEmpty {
            let (rule, multiplier) = queue.removeFirst()
            rule.contents.forEach { colour, count in
                bagCount += count * multiplier
                queue.append((rules[colour]!, count * multiplier))
            }
        }

        print("A shiny gold bag must contain \(bagCount) other bags.")
    }
}

InputData.allCases.forEach(Part2.run)
