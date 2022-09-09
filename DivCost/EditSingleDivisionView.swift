//
//  EditSingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/09/2022.
//

import SwiftUI

struct EditSingleDivisionView: View {
    
    @Binding var division: Division
    
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    var body: some View {
        List {
            HStack {
                TextField("New Division Name", text: $newDivisionName)
                Spacer()
                Button(action: {
                    division.name = newDivisionName
                    newDivisionName = ""
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(newDivisionName.isEmpty)
            }
            Text("People:")
                .font(.headline)
            ForEach(division.people) { person in
                Text(person.name)
            }
            .onDelete { indices in
                withAnimation {
                    division.people.remove(atOffsets: indices)
                }
            }
            .padding(.leading)
            HStack {
                TextField("New Person", text: $newPerson)
                Spacer()
                Button(action: {
                    withAnimation {
                        division.people.append(Person(name: newPerson))
                    }
                    newPerson = ""
                }) {
                    Image(systemName: "plus")
                }
                .disabled(newPerson.isEmpty)
            }
            .padding(.leading)
        }
        .navigationTitle(division.name)
    }
}

struct EditSingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSingleDivisionView(division: .constant(Division.sampleDivisions[1]))
    }
}
