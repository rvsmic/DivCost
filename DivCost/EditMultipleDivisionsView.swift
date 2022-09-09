//
//  EditMultipleDivisionsView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/09/2022.
//

import SwiftUI

struct EditMultipleDivisionsView: View {
    
    @Binding var data: MultipleDivisions.MultipleData
    
    @State private var newPeople: [Person] = []
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    var body: some View {
        List {
            Section {
                TextField("Division Name", text: $newDivisionName)
                
                Text("People:")
                    .font(.headline)
                ForEach(newPeople) { person in
                    Text(person.name)
                }
                .onDelete { indices in
                    newPeople.remove(atOffsets: indices)
                }
                .padding(.leading)
                HStack {
                    TextField("New Person", text: $newPerson)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            newPeople.append(Person(name: newPerson))
                        }
                        newPerson = ""
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(newPerson.isEmpty)
                }
                .padding(.leading)
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            data.divisions.append(Division(name: newDivisionName, people: newPeople))
                        }
                        newPerson = ""
                        newDivisionName = ""
                        withAnimation {
                            newPeople.removeAll()
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.headline.weight(.heavy))
                    }
                    .disabled(newDivisionName.isEmpty || newPeople.isEmpty)
                    Spacer()
                }
                .listRowBackground((newDivisionName.isEmpty || newPeople.isEmpty) ? Color.black.opacity(0.2) : Color.accentColor)

            } header: {
                Text("New Division")
            }
            
            Section {
                ForEach(data.divisions) { division in
                    Text(division.name)
                }
                .onDelete { indices in
                    data.divisions.remove(atOffsets: indices)
                }
            } header: {
                Text("Divisions")
            }
        }
        .navigationTitle("Edit Divisions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditMultipleDivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditMultipleDivisionsView(data: .constant(MultipleDivisions.sampleData.multipleData))
        }
    }
}
