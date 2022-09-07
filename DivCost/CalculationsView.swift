//
//  CalculationsView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct CalculationsView: View {
    let calculations: [Calculations]
    var body: some View {
        List {
            Section {
                ForEach(calculations) { calculation in
                    HStack {
                        Text(calculation.debtorName)
                        Spacer()
                        VStack {
                            Text("\(calculation.value, specifier: "%.2f") zł")
                                .font(.footnote)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.accentColor)
                        Spacer()
                        Text(calculation.payerName)
                    }
                    .listRowSeparator(.hidden)
                    .font(.headline)
                }
            } header: {
                Spacer()
            } footer: { //idk po co
                Text("fin.")
                    .font(.caption.italic())
                    .foregroundColor(.gray)
                    .listRowSeparator(.hidden)
            }

        }
        .listStyle(.plain)
        .navigationTitle("Calculated Divisions")
    }
}

struct CalculationsView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationsView(calculations: Division.sampleDivisions[1].countUp())
    }
}
