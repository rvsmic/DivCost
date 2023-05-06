//
//  ManageDivisionCardView.swift
//  DivCost
//
//  Created by Michał Rusinek on 29/04/2023.
//

import SwiftUI

struct ManageDivisionCardView: View {
    let division: Division
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(UIColor.systemBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(division.theme.mainColor, lineWidth: 5)
                        .opacity(0.3)
                }
            VStack {
                Text(division.name)
                    .font(.title).bold()
                    .padding(.bottom,5)
                HStack {
                    Label(division.getStringDate(), systemImage: "calendar")
                        .labelStyle(SmallDistanceLabel())
                    Spacer()
                    Label("\(division.total, specifier: "%.2f") zł", systemImage: "banknote")
                        .labelStyle(SmallDistanceLabel())
                    Spacer()
                    Label("\(division.people.count)", systemImage: "person.2")
                        .labelStyle(SmallDistanceLabel())
                }
            }
            .padding()
        }
    }
}

struct ManageDivisionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ManageDivisionCardView(division: Division.sampleDivisions[1])
            .frame(height: 50)
    }
}
