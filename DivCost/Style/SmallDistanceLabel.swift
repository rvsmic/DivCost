//
//  SmallIconLabel.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

//w ios16 dystans miedzy ikona a tekstem z automatu robil sie nieregularny
struct SmallDistanceLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}
