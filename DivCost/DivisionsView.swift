//
//  ContentView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct DivisionsView: View {
    @Binding var divisions: [Division]
    var body: some View {
        List {
            Section {
                ForEach($divisions) { $division in
                    NavigationLink(destination: SingleDivisionView(division: $division)) {
                        HStack {
                            Text(division.name)
                                .font(.headline)
                            Spacer()
                            Text("\(division.total, specifier: "%.2f") zł")
                        }
                        .padding()
                    }
                }
            } header: {
                HStack {
                    Text("Divisions")
                    Spacer()
                    Text("Total")
                        .padding(.trailing)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("DivCost")
    }
}

struct DivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DivisionsView(divisions: .constant(Division.sampleDivisions))
        }
    }
}
