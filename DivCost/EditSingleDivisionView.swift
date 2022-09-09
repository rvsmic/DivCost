//
//  EditSingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/09/2022.
//

import SwiftUI

struct EditSingleDivisionView: View {
    
    @Binding var data: Division.Data
    
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    var body: some View {
        List {
            HStack {
                TextField("New Division Name", text: $newDivisionName)
                Spacer()
                Button(action: {
                    data.name = newDivisionName
                    newDivisionName = ""
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(newDivisionName.isEmpty)
            }
            Text("People:")
                .font(.headline)
            ForEach(data.people) { person in
                Text(person.name)
            }
            .onDelete { indices in
                withAnimation {
                    data.people.remove(atOffsets: indices)
                }
            }
            .padding(.leading)
            HStack {
                TextField("New Person", text: $newPerson)
                Spacer()
                Button(action: {
                    withAnimation {
                        data.people.append(Person(name: newPerson))
                    }
                    newPerson = ""
                }) {
                    Image(systemName: "plus")
                }
                .disabled(newPerson.isEmpty)
            }
            .padding(.leading)
        }
        .navigationTitle(data.name)
    }
}

struct EditSingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSingleDivisionView(data: .constant(Division.sampleDivisions[1].data))
    }
}
