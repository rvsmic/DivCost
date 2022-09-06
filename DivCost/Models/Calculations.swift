//
//  Calculations.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation

struct Calculations: Identifiable {
    let id: UUID
    var payerName: String
    var debtorName: String
    var value: Double
    
    init(id: UUID = UUID(), payerName: String, debtorName: String, value: Double) {
        self.id = id
        self.payerName = payerName
        self.debtorName = debtorName
        self.value = value
    }
}
