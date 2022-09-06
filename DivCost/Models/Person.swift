//
//  Person.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation

struct Person: Identifiable, Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        if lhs.balance < rhs.balance {
            return false
        } else {
            return true
        }
    }
    
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
    var balance: Double {
        var balance: Double = total
        for debt in debts {
            balance -= debt.price
        }
        return balance
    }
    var staticBalance: Double
    
    init(id: UUID = UUID(), name: String, expenses: [Product] = [], debts: [Product] = [], staticBalance: Double = 0) {
        self.id = id
        self.name = name
        self.expenses = expenses
        self.debts = debts
        self.staticBalance = staticBalance
    }
}

extension Person {
    static let samplePeople: [Person] = [Person(name: "Miłosz"), Person(name: "Michał", expenses: Product.sampleProducts), Person(name: "Daniel", debts: Product.sampleProducts) ]
}
