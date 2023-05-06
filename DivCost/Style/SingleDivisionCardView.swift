//
//  SingleDivisionCardView.swift
//  DivCost
//
//  Created by Michał Rusinek on 11/04/2023.
//

import SwiftUI

struct SingleDivisionCardView: View {
    let division: Division
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(division.name)
                    .font(.title.bold())
                    .foregroundColor(.primary)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(division.theme.mainColor)
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
                    .font(.caption)
                    .padding(10)
                    .foregroundColor(division.theme.textColor)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct SingleDivisionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDivisionCardView(division: Division.sampleDivisions[1])
            .frame(height: 100)
    }
}
