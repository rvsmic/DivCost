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
        Text("A")
    }
}

struct SingleDivisionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDivisionCardView(division: Division.sampleDivisions[1])
    }
}
