//
//  ContentView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct DivisionsView: View {
    
    @Binding var divisions: [Division]
    
    @State private var showEditSheet = false
    
    var body: some View {
        Form {
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
            //.listStyle(.plain)
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button("Edit", action: {
                    showEditSheet = true
                })
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationView {
                EditMultipleDivisionsView(divisions: $divisions) //przekazywac data a nie faktyczne
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showEditSheet = false
                            }
                            .foregroundColor(.red)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update") {
                                showEditSheet = false
                            }
                        }
                    }
            }
        }
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
