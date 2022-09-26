//
//  DatePickerView.swift
//  DivCost
//
//  Created by Michał Rusinek on 26/09/2022.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    let color: Color
    var body: some View {
        VStack {
            DatePicker("Date", selection: $date, displayedComponents: [.date])
                .labelsHidden()
                .accentColor(color)
                .foregroundColor(.red)
                .datePickerStyle(.graphical)
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(date: .constant(Date()), color: .yellow)
    }
}
