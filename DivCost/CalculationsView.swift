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
    
    var namespace: Namespace.ID
    
    @Environment(\.colorScheme) var colorScheme
    
    init(calculations: [Calculations], theme: Theme, namespace: Namespace.ID) {
        self.calculations = calculations
        self.theme = theme
        self.namespace = namespace
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(theme.mainColor)
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.thinMaterial)
                VStack {
                    Spacer()
                    Text("Calculated Divisions:")
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    ScrollView {
                        ForEach(calculations) { calculation in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.systemBackground))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
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
                            .padding()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        Spacer()
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .matchedGeometryEffect(id: "calculationsBG", in: namespace)
    }
}

struct CalculationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculationsView(calculations: Division.sampleDivisions[1].countUp(), theme: .poppy, namespace: Namespace.init().wrappedValue)
                .preferredColorScheme(.light)
            CalculationsView(calculations: Division.sampleDivisions[1].countUp(), theme: .poppy, namespace: Namespace.init().wrappedValue)
                .preferredColorScheme(.dark)
        }
    }
}
