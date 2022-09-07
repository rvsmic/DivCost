//
//  CheckBoxView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct CheckBoxView: View {
    
    let text: String
    @Binding var checked: Bool
    
    var body: some View {
        Label(text, systemImage: checked ? "checkmark.circle.fill" : "checkmark.circle")
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(text: "Somebody", checked: .constant(false))
    }
}
