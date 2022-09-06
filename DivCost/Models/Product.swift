//
//  Product.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import Foundation

struct Product: Identifiable {
    let id: UUID
    var name: String
    var price: Double
    
    init(id: UUID = UUID(), name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
}

extension Product {
    static let sampleProducts: [Product] = [Product(name: "Piwo", price: 20), Product(name: "Uber", price: 15.80), Product(name: "Pizza", price: 30)]
}
