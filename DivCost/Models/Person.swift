//
//  Person.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation

struct Person: Identifiable {
    let id: UUID
    var name: String
    var expenses: [Product]
    var debts: [Product]
    var total: Double {
        var total: Double = 0
        for expense in expenses {
            total += expense.price
        }
        return total
    }
    
    init(id: UUID = UUID(), name: String, expenses: [Product] = [], debts: [Product] = []) {
        self.id = id
        self.name = name
        self.expenses = expenses
        self.debts = debts
    }
}

extension Person {
    static let samplePeople: [Person] = [Person(name: "Miłosz"), Person(name: "Michał", expenses: Product.sampleProducts), Person(name: "Daniel", debts: Product.sampleProducts) ]
}
