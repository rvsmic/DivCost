//
//  Division.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation
import SwiftUI

struct Division: Identifiable, Codable, Comparable {
    static func < (lhs: Division, rhs: Division) -> Bool {
        if lhs.date < rhs.date {
            return false
        } else {
            return true
        }
    }
    let id: UUID
    var name: String
    var people: [Person]
    var date: Date
    var theme: Theme
    var total: Double {
        var total: Double = 0
        for person in people {
            total += person.total
        }
        return total
    }
    
    init(id: UUID = UUID(), name: String, people: [Person] = [], date: Date, theme: Theme) {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.people = people
        self.date = date
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
    
    func getStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    func anyNamesEmpty() -> Bool {
        for person in people {
            if person.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
        }
        return false
    }
    
    mutating func whitespacesNamesFix() {
        for i in 0..<people.count {
            people[i].name = people[i].name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

extension Division {
    static let sampleDivisions: [Division] = [Division(name: "Warszawa", date: Date(), theme: .poppy), Division(name: "Starówka", people: Person.samplePeople, date: Date()-20, theme: .navy), Division(name: "Miłocin", date: Date()-1, theme: .salmon)]
    static let emptyDivision: Division = Division(name: "", date: Date(), theme: .div_cost)
}

extension Division {
    struct Data {
        var name: String = ""
        var people: [Person] = []
        var date: Date = Date()
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
        
        mutating func addCustomProduct(newName: String, customAmount: [UUID:String], buyerId: UUID, debtorsId: [UUID]) {
            let totalPrice = customAmount.values.map{ Double($0) ?? 0}.reduce(0, +)
            let buyerProduct = Product(name: newName, price: totalPrice)
            
            for i in 0..<people.count {
                for j in 0..<debtorsId.count {
                    if people[i].id == debtorsId[j] {
                        people[i].debts.append(Product(name: newName, price: Double(customAmount[people[i].id] ?? "0")!))
                        break
                    }
                }
                
                if people[i].id == buyerId {
                    people[i].expenses.append(buyerProduct)
                }
            }
        }
        
        mutating func checkReset() {
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
                    while(people[i].expenses.count > 0) {
                        removeProduct(productName: people[i].expenses[0].name)
                    }
                    let oldDebts = people[i].debts
                    people.remove(at: i)
                    recalculateDebts(oldDebts: oldDebts)
                    break
                }
            }
        }
        
        mutating func recalculateDebts(oldDebts: [Product]) {
            for i in 0..<oldDebts.count {
                var buyerID = UUID()
                var debtorsID: [UUID] = []
                let productName = oldDebts[i].name
                var productPrice = 0.0
                for j in 0..<people.count {
                    for k in 0..<people[j].debts.count {
                        if people[j].debts[k].name == productName {
                            debtorsID.append(people[j].id)
                            break
                        }
                    }
                }
                for j in 0..<people.count {
                    for k in 0..<people[j].expenses.count {
                        if people[j].expenses[k].name == productName {
                            buyerID = people[j].id
                            productPrice = people[j].expenses[k].price
                            removeProduct(productName: productName)
                            break
                        }
                    }
                }
                addProduct(newName: productName, newPrice: productPrice, buyerId: buyerID, debtorsId: debtorsID)
            }
        }
        
        func anyNamesEmpty() -> Bool {
            for person in people {
                if person.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return true
                }
            }
            return false
        }
        
        mutating func whitespacesNamesFix() {
            for i in 0..<people.count {
                people[i].name = people[i].name.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        mutating func checkAll() {
            for i in 0..<people.count {
                people[i].checked = true
            }
        }
        
        mutating func unCheckAll() {
            for i in 0..<people.count {
                people[i].checked = false
            }
        }
        
        func allChecked() -> Bool {
            for person in people {
                if !person.checked {
                    return false
                }
            }
            return true
        }
        
        //kiedys moze dodac po prostu liste dluznikow do produktu to by sie tu nie szukalo
        mutating func updateChecks(expenseName: String) {
            for i in 0..<people.count {
                for debt in people[i].debts {
                    if debt.name == expenseName {
                        people[i].checked = true
                        break
                    }
                }
            }
        }
    }
    
    var data: Data {
        Data(name: name, people: people.sorted(by: Person.nameSort), date: date, theme: theme)
    }
    
    mutating func update(from data: Data) {
        name = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        people = data.people
        date = data.date
        theme = data.theme
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        people = data.people
        date = data.date
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
