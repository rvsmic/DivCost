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
                    NavigationLink(destination: CalculationsView(calculations: division.countUp())) {
                        Label("Calculated Divisions", systemImage: "function")
                            .font(.headline)
                        .foregroundColor(.accentColor)
                    }
                    HStack {
                        Label("Total", systemImage: "banknote")
                        Spacer()
                        Text("\(division.total, specifier: "%.2f") zł")
                    }
                } header: {
                    Text("Summary")
                }
                Section {
                    ForEach(division.people.sorted()) { person in
                        Section {
                            ForEach(person.expenses.sorted()) { expense in
                                HStack {
                                    Label("\(expense.name)", systemImage: "diamond")
                                    Spacer()
                                    Text("\(expense.price, specifier: "%.2f") zł") //można potem dodać wybieranie waluty i guess
                                }
                                .listRowSeparator(.hidden)
                            }
                        } header: {
                            HStack {
                                Label("\(person.name)", systemImage: "person")
                                    .font(.headline)
                                Spacer()
                                Text("\(person.balance, specifier: "%.2f") zł")
                                    .font(.footnote.bold())
                                    .foregroundColor(person.balance < 0 ? Color.red : Color.green)
                            }
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
