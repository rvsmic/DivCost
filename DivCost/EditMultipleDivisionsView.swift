//
//  EditMultipleDivisionsView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/09/2022.
//

import SwiftUI

struct EditMultipleDivisionsView: View {
    
    @Binding var data: MultipleDivisions.MultipleData
    let theme: Theme = .div_cost
    
    init(data: Binding<MultipleDivisions.MultipleData>) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._data = data
    }
    
    var body: some View {
        List {
            Section ("Divisions") {
                ForEach(data.divisions.sorted()) { division in
                    ManageDivisionCardView(division: division)
                    .fixedSize(horizontal: false, vertical: true)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                data.removeDivision(divisionID: division.id)
                            }
                        } label: {
                            Label("", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
                .padding(.vertical,0)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Spacer(minLength: 200)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .background(theme.mainColor.opacity(0.1))
        .background(.ultraThinMaterial)
        .listStyle(.plain)
        .interactiveDismissDisabled()
    }
}

struct EditMultipleDivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditMultipleDivisionsView(data: .constant(MultipleDivisions.sampleData.multipleData))
        }
    }
}
