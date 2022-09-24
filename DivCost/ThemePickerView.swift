//
//  ThemePickerView.swift
//  DivCost
//
//  Created by Michał Rusinek on 23/09/2022.
//

import SwiftUI

struct ThemePickerView: View {
    @Binding var selection: Theme
    var body: some View {
        VStack {
            Picker("Theme", selection: $selection) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(theme.mainColor)
                        Text(theme.name)
                            .font(.headline)
                            .foregroundColor(theme.textColor)
                    }
                }
            }
            .pickerStyle(.wheel)
        }
        .fixedSize()
        .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView(selection: .constant(.ruddy))
    }
}
