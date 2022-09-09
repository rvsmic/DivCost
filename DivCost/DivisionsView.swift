//
//  ContentView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct DivisionsView: View {
    
    @Binding var divisions: [Division]
    
    @State private var data = MultipleDivisions.MultipleData()
    
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
                    let multipleDivisions = MultipleDivisions(divisions: divisions)
                    data = multipleDivisions.multipleData
                    
                    showEditSheet = true
                })
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationView {
                EditMultipleDivisionsView(data: $data)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showEditSheet = false
                            }
                            .foregroundColor(.red)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update") {
                                var multipleDivisions = MultipleDivisions(divisions: divisions)
                                multipleDivisions.update(from: data)
                                divisions = multipleDivisions.unwrap()
                                //divisions = divisions.sorted() //moze wg daty sortowanie kiedys
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
