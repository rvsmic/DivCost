//
//  Person.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation
import SwiftUI

struct Person: Identifiable, Comparable, Codable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        if (lhs.balance,rhs.name.lowercased()) < (rhs.balance,lhs.name.lowercased()) {
            return false
        } else {
            return true
        }
    }
    
    static func nameSort (lhs: Person, rhs: Person) -> Bool {
        if lhs.name.lowercased() < rhs.name.lowercased() {
            return true
        } else {
            return false
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
    var checked: Bool
    
    init(id: UUID = UUID(), name: String, expenses: [Product] = [], debts: [Product] = [], staticBalance: Double = 0, checked: Bool = false) {
        self.id = id
        self.name = name
        self.expenses = expenses
        self.debts = debts
        self.staticBalance = staticBalance
        self.checked = checked
    }
    
    static func removePerson(people: [Person], personID: UUID) -> [Person]{
        var newPeople: [Person] = []
        for i in 0..<people.count {
            if people[i].id != personID {
                newPeople.append(people[i])
            }
        }
        return newPeople
    }
}

extension Person {
    static let samplePeople: [Person] = [Person(name: "Miłosz"), Person(name: "Michał", expenses: Product.sampleProducts), Person(name: "Daniel", debts: Product.sampleProducts) ]
}
