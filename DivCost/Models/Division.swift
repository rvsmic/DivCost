//
//  Division.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation

struct Division: Identifiable {
    let id: UUID
    var name: String
    var people: [Person]
    var total: Double {
        var total: Double = 0
        for person in people {
            total += person.total
        }
        return total
    }
    
    init(id: UUID = UUID(), name: String, people: [Person] = []) {
        self.id = id
        self.name = name
        self.people = people
    }
    
    func countUp() -> [Calculations] {
        var calculations: [Calculations] = []
        var calcPeople: [Person] = people.sorted()
        for i in 0..<calcPeople.count {
            calcPeople[i].staticBalance = calcPeople[i].balance
        }
        for var person in calcPeople {
            for i in (0...calcPeople.count-1).reversed() {
                if (person.staticBalance + calcPeople[i].staticBalance >= 0 && calcPeople[i].staticBalance < 0) {
                    calculations.append(Calculations(payerName: person.name, debtorName: calcPeople[i].name, value:  -1 * calcPeople[i].staticBalance))
                    person.staticBalance += calcPeople[i].staticBalance
                    calcPeople[i].staticBalance = 0
                } else if (person.staticBalance > 0 && calcPeople[i].staticBalance < 0) {
                    calculations.append(Calculations(payerName: person.name, debtorName: calcPeople[i].name, value: person.staticBalance))
                    person.staticBalance = 0
                    calcPeople[i].staticBalance += person.staticBalance
                }
            }
        }
        return calculations
    }
    
    mutating func addProduct(newName: String, newPrice: Double, buyerId: UUID, debtorsId: [UUID]) {
        let newProduct = Product(name: newName, price: newPrice)
        let dividedProduct = Product(name: newName, price: Double(newPrice / Double(debtorsId.count)))
        
        for i in 0..<people.count {
            for j in 0..<debtorsId.count {
                if people[i].id == debtorsId[j] {
                    people[i].debts.append(dividedProduct)
                    break
                }
            }
            
            if people[i].id == buyerId {
                people[i].expenses.append(newProduct)
            }
        }
    }
}

extension Division {
    static let sampleDivisions: [Division] = [Division(name: "Warszawa"), Division(name: "Starówka", people: Person.samplePeople), Division(name: "Miłocin")]
}
