//
//  InputData.swift
//  Day 25
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [Int] {
        switch self {

        case .example: return [5764801, 17807724]

        case .challenge: return [13316116, 13651422]

        }
    }
}
