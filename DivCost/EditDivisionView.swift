//
//  EditDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct EditDivisionView: View {
    
    @Binding var division: Division
    
    @State private var newName: String = ""
    
    @State private var checked: [CheckedData] = []
    
    init(division: Binding<Division>) {
        self._division = division
        
        for person in division.people {
            checked.append(CheckedData(personID: person.id))
        }
    }
    
    var body: some View {
        List {
            Section {
                ForEach(division.people.sorted()) { person in
                    Text(person.name)
                        .font(.headline)
                    ForEach(person.expenses.sorted()) { expense in
                        HStack {
                            Text(expense.name)
                            Spacer()
                            Text("\(expense.price, specifier: "%.2f")")
                        }
                        .padding(.leading)
                    }
                    VStack (alignment: .leading){
                        TextField("New product", text: $newName)
                        ForEach(division.people.sorted(by: Person.nameSort)) { dude in
                            CheckBoxView(text: dude.name, checked: .constant(false)) //wut
                                .padding(2)
                        }
                        Button("Add", action: {})
                    }
                    Spacer()
                }
            } header: {
                Text("Expenses")
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(division.name) - edit")
    }
}

struct EditDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditDivisionView(division: .constant(Division.sampleDivisions[1]))
        }
    }
}

struct CheckedData {
    var checked: Bool
    var personId: UUID
                
                init(checked: Bool = false, personID: UUID) {
                    self.checked = checked
                    self.personId = personID
                }
    
    mutating func check() {
        checked.toggle()
    }
}
