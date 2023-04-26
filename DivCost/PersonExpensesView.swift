//
//  PersonExpensesView.swift
//  DivCost
//
//  Created by Michał Rusinek on 10/04/2023.
//

import SwiftUI

struct PersonExpensesView: View {
    let person: Person
    let theme: Theme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(UIColor.systemBackground))
//                .overlay {
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
//                }
            VStack {
                HStack {
                    Label("\(person.name)", systemImage: "person")
                        .font(.headline)
                        .labelStyle(DualColorLabel(iconColor: theme.mainColor))
                    Spacer()
                    Text("\(person.balance, specifier: "%.2f") zł")
                        .font(.footnote.bold())
                        .foregroundColor(getBalanceColor(balance: person.balance))
                }
                Group {
                    if hasExpenses(expenses: person.expenses) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.green.opacity(0.2))
                            VStack {
                                ForEach(person.expenses.sorted()) { expense in //
                                    HStack {
                                        Label("\(expense.name)", systemImage: "chevron.up")
                                        Spacer()
                                        Text("\(expense.price, specifier: "%.2f") zł") //można potem dodać wybieranie waluty i guess
                                    }
                                    .padding(.vertical,2)
                                    .foregroundColor(Color.darkGreen)
                                    //.listRowSeparator(.hidden)
                                    //.listRowBackground(Color.green.opacity(0.2))
                                }
                            }
                            .padding()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    } else {}
                }
                Group {
                    if hasDebts(debts: person.debts) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red.opacity(0.2))
                            VStack {
                                ForEach(person.debts.sorted()) { debt in //
                                    HStack {
                                        Label("\(debt.name)", systemImage: "chevron.down")
                                        Spacer()
                                        Text("\(debt.price, specifier: "%.2f") zł")
                                    }
                                    .padding(.vertical,2)
                                    .foregroundColor(Color.darkRed)
                                    //.listRowSeparator(.hidden)
                                    //.listRowBackground(Color.red.opacity(0.2))
                                }
                            }
                            .padding()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    } else {}
                }
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical,-10)
    }
}

struct PersonExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        PersonExpensesView(person: Person.samplePeople[1], theme: .royal)
    }
}


extension PersonExpensesView {
    func getBalanceColor(balance: Double) -> Color {
        if balance == 0 {
            return .gray
        } else if balance > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    func hasExpenses(expenses: [Product]) -> Bool {
        if expenses.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func hasDebts(debts: [Product]) -> Bool {
        if debts.count > 0 {
            return true
        } else {
            return false
        }
    }
}

extension Color {
    static let darkGreen = Color(red: 100/255, green: 160/255, blue: 100/255)
    static let darkRed = Color(red: 160/255, green: 100/255, blue: 100/255)
}
