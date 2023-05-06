//
//  CalculationsView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI
import SpriteKit

struct CalculationsView: View {
    let calculations: [Calculations]
    let theme: Theme
    
    init(calculations: [Calculations], theme: Theme) {
        self.calculations = calculations
        self.theme = theme
    }
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            List {
                ForEach(calculations) { calculation in
                    SingleCalculationView(calculation: calculation, theme: theme)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.top,20)
                Spacer(minLength: 200)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .background(theme.mainColor.opacity(0.1))
            .background(.ultraThinMaterial)
            .listStyle(.plain)
        }
        .navigationTitle("Calculated Divisions")
    }
}

struct CalculationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculationsView(calculations: Calculations.sampleCalculations, theme: .golden_gate)
        }
    }
}
