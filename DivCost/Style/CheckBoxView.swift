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
    let color: Color
    let textColor: Color
    @Binding var allChecked: Bool
    @Binding var divisionData: Division.Data
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(color)
                .opacity(checked ? 1 : 0)
            RoundedRectangle(cornerRadius: 30)
                .fill(Material.thin)
                .opacity(checked ? 0 : 1)
            Text(text)
                .padding(10)
                .padding(.horizontal, 10)
                .foregroundColor(textColor)
                .opacity(checked ? 1 : 0)
            Text(text)
                .padding(10)
                .padding(.horizontal, 10)
                .foregroundColor(.primary)
                .opacity(checked ? 0 : 1)
            
        }
        .fixedSize()
        .animation(Animation.easeInOut, value: 0.5)
        .onTapGesture {
            checked.toggle()
            allChecked = divisionData.allChecked()
        }
    }
}

struct test: View {
    @State private var checked: Bool = false
    @State private var allChecked: Bool = false
    var body: some View {
        CheckBoxView(text: "Dude", checked: $checked, color: .yellow, textColor: .white, allChecked: $allChecked, divisionData: .constant(Division.sampleDivisions[1].data))
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        test()
    }
}
