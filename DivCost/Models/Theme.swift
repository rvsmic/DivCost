//
//  Theme.swift
//  DivCost
//
//  Created by Michał Rusinek on 22/09/2022.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable, Codable {
    case poppy
    case salmon
    
    case ruddy
    case navy
    
    case divcost
    
    var mainColor: Color {
        Color(name)
    }
    
    var textColor: Color {
        switch self {
        case .poppy, .navy:
            return Color.white
        case .salmon, .ruddy, .divcost:
            return Color.black
        }
    }
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}
