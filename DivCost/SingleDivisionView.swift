//
//  SingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct SingleDivisionView: View {
    
    @Binding var division: Division
    
    @State private var data = Division.Data()
    
    @State private var editSheetShown = false
    
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
                                    Label("\(expense.name)", systemImage: "chevron.up")
                                    Spacer()
                                    Text("\(expense.price, specifier: "%.2f") zł") //można potem dodać wybieranie waluty i guess
                                }
                                
                                .foregroundColor(Color.darkGreen)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.green.opacity(0.2))
                            }
                            ForEach(person.debts.sorted()) { debt in
                                HStack {
                                    Label("\(debt.name)", systemImage: "chevron.down")
                                    Spacer()
                                    Text("\(debt.price, specifier: "%.2f") zł")
                                }
                                .foregroundColor(Color.darkRed)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.red.opacity(0.2))
                            }
                        } header: {
                            HStack {
                                Label("\(person.name)", systemImage: "person")
                                    .font(.headline)
                                Spacer()
                                Text("\(person.balance, specifier: "%.2f") zł")
                                    .font(.footnote.bold())
                                    .foregroundColor(getBalanceColor(balance: person.balance))
                            }
                        }
                    }
                } header: {
                    Text("People")
                }
            }
            //.listStyle(.plain)
            //.padding([.leading,.trailing])
        }
        .navigationTitle(division.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    data = division.data
                    editSheetShown = true
                }
            }
        }
        .sheet(isPresented: $editSheetShown) {
            NavigationView {
                AddExpensesView(data: $data)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                editSheetShown = false
                            }
                            .foregroundColor(.red)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update") {
                                division.update(from: data)
                                division.people.sort(by: Person.nameSort)
                                editSheetShown = false
                            }
                        }
                }
            }
        }
    }
}

struct SingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleDivisionView(division: .constant(Division.sampleDivisions[1]))
        }
    }
}

extension SingleDivisionView {
    func getBalanceColor(balance: Double) -> Color {
        if balance == 0 {
            return .gray
        } else if balance > 0 {
            return .green
        } else {
            return .red
        }
    }
}

extension Color {
    static let darkGreen = Color(red: 100/255, green: 160/255, blue: 100/255)
    static let darkRed = Color(red: 160/255, green: 100/255, blue: 100/255)
}
