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
                        RoundedRectangle(cornerRadius: 30)
                            .fill(theme.mainColor)
                        Text(theme.name)
                            .font(.headline)
                            .foregroundColor(theme.textColor)
                    }
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView(selection: .constant(.ruddy))
    }
}
