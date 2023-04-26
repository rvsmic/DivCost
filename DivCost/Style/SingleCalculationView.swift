//
//  SingleCalculationView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/04/2023.
//

import SwiftUI

struct SingleCalculationView: View {
    let calculation: Calculations
    let theme: Theme
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(UIColor.systemBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(theme.mainColor, lineWidth: 5)
                }
            HStack {
                Text(calculation.debtorName)
                Spacer()
                VStack {
                    Text("\(calculation.value, specifier: "%.2f") zł")
                        .font(.footnote)
                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundColor(theme.mainColor)
                .overlay {
                    VStack {
                        Text("\(calculation.value, specifier: "%.2f") zł")
                            .font(.footnote)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(colorScheme == .dark ? 1 : 0)

                    VStack {
                        Text("\(calculation.value, specifier: "%.2f") zł")
                            .font(.footnote)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.black.opacity(0.7))
                    .opacity(colorScheme == .dark ? 0 : 1)
                }
                Spacer()
                Text(calculation.payerName)
            }
            .padding()
            .font(.headline)
        }
//        .padding()
    }
}

struct SingleCalculationView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCalculationView(calculation: Calculations.sampleCalculations[0], theme: .lemon)
            .frame(height: 50)
    }
}
