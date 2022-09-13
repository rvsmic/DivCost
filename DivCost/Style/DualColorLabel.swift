//
//  DualColorLabel.swift
//  DivCost
//
//  Created by Michał Rusinek on 12/09/2022.
//

import SwiftUI

struct DualColorLabel: LabelStyle {
    let iconColor: Color
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(iconColor)
            configuration.title
        }
    }
}
