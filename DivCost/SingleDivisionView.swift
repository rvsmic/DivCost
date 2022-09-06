//
//  SingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct SingleDivisionView: View {
    @Binding var division: Division
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach($division.people) { $person in
                        Section {
                            ForEach($person.expenses) { $expense in
                                HStack {
                                    Label("\(expense.name)", systemImage: "diamond")
                                    Spacer()
                                    Text("\(expense.price, specifier: "%.2f") zł") //można potem dodać wybieranie waluty i guess
                                }
                                .listRowSeparator(.hidden)
                            }
                        } header: {
                            Label("\(person.name)", systemImage: "person")
                                .font(.headline)
                        }
                    }
                } header: {
                    Text("People")
                }
            }
            .listStyle(.plain)
            .padding([.leading,.trailing])
        }
        .navigationTitle(division.name)
    }
}

struct SingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleDivisionView(division: .constant(Division.sampleDivisions[1]))
        }
    }
}
