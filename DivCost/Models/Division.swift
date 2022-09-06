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
}

extension Division {
    static let sampleDivisions: [Division] = [Division(name: "Warszawa"), Division(name: "Starówka", people: Person.samplePeople), Division(name: "Miłocin")]
}
