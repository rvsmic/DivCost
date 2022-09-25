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
    
    var body: some View {
//        Label(text, systemImage: checked ? "checkmark.circle.fill" : "checkmark.circle")
//            .labelStyle(DualColorLabel(iconColor: color))
//            .animation(Animation.easeInOut, value: 0.5)
//            .onTapGesture {
//                checked.toggle()
//            }
//            .foregroundColor(textColor)
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .opacity(checked ? 1 : 0)
            RoundedRectangle(cornerRadius: 20)
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
        }
    }
}

//struct CheckBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckBoxView(text: "Somebody", checked: .constant(false))
//    }
//}

struct test: View {
    @State private var checked: Bool = false
    var body: some View {
        CheckBoxView(text: "Dude", checked: $checked, color: .yellow, textColor: .white)
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        test()
    }
}
