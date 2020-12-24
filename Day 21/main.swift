//
//  main.swift
//  Day 21
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 21:")

enum Part1 {
    static func allergenSets(from line: String) -> [String: Set<String>] {
        let parts = line.components(separatedBy: " (contains ")
        let ingredients = Set(parts[0].components(separatedBy: " "))
        let allergens = parts[1].dropLast().components(separatedBy: ", ")
        return allergens.reduce(into: [String: Set<String>]()) { $0[$1] = ingredients }
    }

    static func run(_ source: InputData) {
        let input = source.data
        var ingredients: [String: (count: Int, allergen: String?)] = [:]
        var allergens: [String: Set<String>] = [:]

        for line in input {
            let sets = allergenSets(from: line)
            let lineIngredients = sets.values.first!
            for ingredient in lineIngredients {
                let value = ingredients[ingredient] ?? (0, nil)
                ingredients[ingredient] = (value.count + 1, nil)
            }
            for allergen in sets.keys {
                if let existing = allergens[allergen] {
                    allergens[allergen] = existing.intersection(sets[allergen]!)
                } else {
                    allergens[allergen] = sets[allergen]!
                }
            }
        }

        while !allergens.isEmpty {
            allergens.filter({ _, value in value.count == 1 }).forEach { key, value in
                let ingredient = ingredients[value.first!]!
                ingredients[value.first!] = (ingredient.count, key)
                allergens.removeValue(forKey: key)
            }
            allergens.forEach { key, value in
                var value = value
                ingredients.forEach { name, ingredient in
                    if let _ = ingredient.allergen {
                        value.remove(name)
                    }
                }
                allergens[key] = value
            }
        }

        let count = ingredients.filter({ _, value in value.allergen == nil })
            .reduce(0) { $0 + $1.value.count }

        print("Part 1 (\(source)): \(count)")
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
