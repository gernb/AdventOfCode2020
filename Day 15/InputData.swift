//
//  InputData.swift
//  Day 15
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [Int] {
        switch self {

        case .example: return "0,3,6".components(separatedBy: ",").compactMap(Int.init)

        case .challenge: return "19,0,5,1,10,13".components(separatedBy: ",").compactMap(Int.init)

        }
    }
}
