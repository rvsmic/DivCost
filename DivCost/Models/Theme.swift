//
//  Theme.swift
//  DivCost
//
//  Created by Michał Rusinek on 22/09/2022.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable, Codable {
    case black_and_white
    case stone
    case poppy
    case golden_gate
    case carmine
    case salmon
    case orange
    case div_cost
    case lemon
    case pear
    case mint
    case army
    case fern
    case moss
    case emerald
    case duck
    case navy
    case ruddy
    case celtic
    case chestnut
    case desert
    case peach
    case royal
    case mauve
    
    var mainColor: Color {
        Color(name)
    }
    
    var textColor: Color {
        switch self {
        case .golden_gate, .poppy, .chestnut, .emerald, .army, .duck, .navy, .royal, .carmine, .celtic, .stone, .moss:
            return Color.white
        case .salmon, .desert, .peach, .lemon, .div_cost, .pear, .ruddy, .mauve, .mint, .orange, .fern:
            return Color.black
        case .black_and_white:
            return Color(UIColor.systemBackground)
        }
    }
    
    var name: String {
        rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    var id: String {
        name
    }
}
