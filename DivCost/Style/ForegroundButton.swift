//
//  ForegroundButton.swift
//  DivCost
//
//  Created by Michał Rusinek on 07/09/2022.
//

import SwiftUI

struct ForegroundButton: View {
    let backgroundColor: Color
    let foregroundColor: Color
    let image: String
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            Image(systemName: image)
                .padding()
                .foregroundColor(foregroundColor)
                .font(.largeTitle)
        }
        .fixedSize()
    }
}

struct ForegroundButton_Previews: PreviewProvider {
    static var previews: some View {
        ForegroundButton(backgroundColor: .yellow, foregroundColor: .black, image: "plus")
    }
}
