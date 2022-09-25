//
//  Division.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation
import SwiftUI

struct Division: Identifiable, Codable {//dodać date!
    let id: UUID
    var name: String
    var people: [Person]
    var theme: Theme
    var total: Double {
        var total: Double = 0
        for person in people {
            total += person.total
        }
        return total
    }
    
    init(id: UUID = UUID(), name: String, people: [Person] = [], theme: Theme) {
        self.id = id
        self.name = name
        self.people = people
        self.theme = theme
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
    
    static func getFromID(divisions: Binding<[Division]>, ID: UUID) -> Binding<Division> {
        for division in divisions {
            if division.id == ID {
                return division
            }
        }
        return divisions[0]
    }
}

extension Division {
    static let sampleDivisions: [Division] = [Division(name: "Warszawa", theme: .poppy), Division(name: "Starówka", people: Person.samplePeople, theme: .navy), Division(name: "Miłocin", theme: .salmon)]
}

extension Division {
    struct Data {
        var name: String = ""
        var people: [Person] = []
        var theme: Theme = .ruddy
        
        
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
        
        mutating func checkReset() {    //wtf
            for i in 0..<people.count {
                if people[i].checked {
                    people[i].checked = false
                }
            }
        }
        
        mutating func removeProduct(productName: String) {
            for i in 0..<people.count {
                for j in 0..<people[i].expenses.count {
                    if people[i].expenses[j].name == productName {
                        people[i].expenses.remove(at: j)
                        break
                    }
                }
            }
            
            for i in 0..<people.count {
                for j in 0..<people[i].debts.count {
                    if people[i].debts[j].name == productName {
                        people[i].debts.remove(at: j)
                        break
                    }
                }
            }
        }
        
        mutating func removePerson(personID: UUID) {
            for i in 0..<people.count {
                if (people[i].id == personID) {
                    for j in 0..<people[i].expenses.count {
                        removeProduct(productName: people[i].expenses[j].name)
                    }
                    people.remove(at: i)
                    break
                }
            }
        }
    }
    
    var data: Data {
        Data(name: name, people: people, theme: theme)
    }
    
    mutating func update(from data: Data) {
        name = data.name
        people = data.people
        theme = data.theme
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        people = data.people
        theme = data.theme
    }
}


struct MultipleDivisions {
    var divisions: [Division]
    
    init(divisions: [Division]) {
        self.divisions = divisions
    }
    
    mutating func update(from multipleData: MultipleData) {
        divisions = multipleData.divisions
    }
    
    func unwrap() -> [Division] {
        return divisions
    }
}

extension MultipleDivisions {
    struct MultipleData {
        var divisions: [Division] = []
        
        mutating func removeDivision(divisionID: UUID) {
            for i in 0..<divisions.count {
                if divisions[i].id == divisionID {
                    divisions.remove(at: i)
                    break
                }
            }
        }
    }
    
    var multipleData: MultipleData {
        MultipleData(divisions: divisions)
    }
}

extension MultipleDivisions {
    static let sampleData: MultipleDivisions = MultipleDivisions(divisions: Division.sampleDivisions)
}
