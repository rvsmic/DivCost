//
//  Theme.swift
//  DivCost
//
//  Created by Michał Rusinek on 22/09/2022.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable, Codable {
    case golden_gate
    case poppy
    case salmon
    case chestnut
    case desert
    case peach
    case lemon
    case div_cost
    case pear
    case emerald
    case army
    case duck
    case ruddy
    case navy
    case mauve
    case royal
    
    var mainColor: Color {
        Color(name)
    }
    
    var textColor: Color {
        switch self {
        case .golden_gate, .poppy, .chestnut, .emerald, .army, .duck, .navy, .royal:
            return Color.white
        case .salmon, .desert, .peach, .lemon, .div_cost, .pear, .ruddy, .mauve :
            return Color.black
        }
    }
    
    var name: String {
        rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    var id: String {
        name
    }
}
