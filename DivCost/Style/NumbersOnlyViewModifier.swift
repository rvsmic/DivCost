//
//  NumberOnlyViewModifier.swift
//  DivCost
//
//  Created by Michał Rusinek on 30/04/2023.
//

import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                var decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                numbers += decimalSeparator
                // fix jak locale ma inny separator niz jezyk iPhona
                if(!text.isEmpty) {
                    if(text.contains(".")) {
                        decimalSeparator = "."
                    } else {
                        decimalSeparator = ","
                    }
                }
                //max 1 "kropka" w decimalu
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                    
                    //max 2 miejsca po kropce
                } else if newValue.components(separatedBy: decimalSeparator).count == 2 {
                    if(newValue.components(separatedBy: decimalSeparator)[1].count > 2) {
                        let filtered = newValue
                        self.text = String(filtered.dropLast())
                    }
                } else {
                    let filtered = newValue.filter { numbers.contains($0) }
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding <String>) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text))
    }
}
