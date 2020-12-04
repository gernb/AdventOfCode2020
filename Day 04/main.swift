//
//  main.swift
//  Day 04
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
    enum RequiredFields: String, CaseIterable {
        case birthYear = "byr"
        case issueYear = "iyr"
        case expirationYear = "eyr"
        case height = "hgt"
        case hairColor = "hcl"
        case eyeColor = "ecl"
        case passportId = "pid"
//        case countryId = "cid"
    }

    static func isValid(_ passport: String) -> Bool {
        let fields = passport.components(separatedBy: .whitespacesAndNewlines)
            .map { $0.components(separatedBy: ":")[0] }
            .compactMap(RequiredFields.init)
        return Set(fields) == Set(RequiredFields.allCases)
    }

    static func run(_ source: String) {
        let input = InputData[source]!
        let valid = input.map { isValid($0) ? 1 : 0 }.reduce(0, +)

        print("Part 1 (\(source)):")
        print("\(input.count) total passports; \(valid) are valid")
    }
}

Part1.run("example")
Part1.run("challenge")

// MARK: - Part 2

print("")

enum Part2 {
    enum Field: String, CaseIterable {
        case birthYear = "byr"
        case issueYear = "iyr"
        case expirationYear = "eyr"
        case height = "hgt"
        case hairColor = "hcl"
        case eyeColor = "ecl"
        case passportId = "pid"
        case countryId = "cid"

        static let requiredFields = Set(allCases).subtracting([.countryId])
    }

    struct Passport {
        let fields: [Field: String]

        init(_ string: String) {
            self.fields = .init(uniqueKeysWithValues: string.components(separatedBy: .whitespacesAndNewlines)
                .map {
                    let parts = $0.components(separatedBy: ":")
                    return (Field(rawValue: parts[0])!, parts[1])
                })
        }

        var isValid: Bool {
            Field.requiredFields.reduce(true) { $0 && hasValid($1) }
        }

        /*
         byr (Birth Year) - four digits; at least 1920 and at most 2002.
         iyr (Issue Year) - four digits; at least 2010 and at most 2020.
         eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
         hgt (Height) - a number followed by either cm or in:
         If cm, the number must be at least 150 and at most 193.
         If in, the number must be at least 59 and at most 76.
         hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
         ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
         pid (Passport ID) - a nine-digit number, including leading zeroes.
         cid (Country ID) - ignored, missing or not.
         */
        func hasValid(_ field: Field) -> Bool {
            guard let data = fields[field] else { return false }
            switch field {
            case .birthYear:
                guard let year = Int(data) else { return false }
                return year >= 1920 && year <= 2002
            case .issueYear:
                guard let year = Int(data) else { return false }
                return year >= 2010 && year <= 2020
            case .expirationYear:
                guard let year = Int(data) else { return false }
                return year >= 2020 && year <= 2030
            case .height:
                if data.hasSuffix("cm") {
                    guard let cm = Int(data.dropLast(2)) else { return false }
                    return cm >= 150 && cm <= 193
                } else if data.hasSuffix("in") {
                    guard let inches = Int(data.dropLast(2)) else { return false }
                    return inches >= 59 && inches <= 76
                } else {
                    return false
                }
            case .hairColor:
                return data.count == 7 && data.hasPrefix("#") && Int(data.dropFirst(), radix: 16) != nil
            case .eyeColor:
                return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(data)
            case .passportId:
                return data.count == 9 && Int(data) != nil
            case .countryId: return true
            }
        }
    }

    static func run(_ source: String) {
        let input = InputData[source]!
        let passports = input.map(Passport.init)
        let valid = passports.map { $0.isValid ? 1 : 0 }.reduce(0, +)

        print("Part 2 (\(source)):")
        print("\(passports.count) total passports; \(valid) are valid")
    }
}

Part2.run("example")
Part2.run("example_invalid")
Part2.run("example_valid")
Part2.run("challenge")
