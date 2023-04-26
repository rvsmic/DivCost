//
//  RightIconLabel.swift
//  DivCost
//
//  Created by Michał Rusinek on 10/04/2023.
//

import SwiftUI

struct RightIconLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}
