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
    
    //@Namespace var namespace
    var namespace: Namespace.ID
    
    let mainColor = Color("MainColor")
    let mainDarkerColor = Color(UIColor(Color("MainColor")).darker())
    
    init(data: Binding<MultipleDivisions.MultipleData>, namespace: Namespace.ID) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._data = data
        self.namespace = namespace
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(mainColor)
                            .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                        
                        List {
                            Section {
                                Text("New Division:")
                                    .font(.footnote.bold())
                                    .foregroundColor(.black)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                    TextField("Division Name", text: $newDivisionName)
                                        .padding()
                                }
                                Text("New People:")
                                    .font(.footnote.bold())
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
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
                                    //.padding(.leading)
                                    .padding()
                                }
                                ForEach(newPeople) { person in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                        Text(person.name)
                                            .padding()
                                    }
                                }
                                .onDelete { indices in
                                    newPeople.remove(atOffsets: indices)
                                }
                                
                                
                                
                                HStack {
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
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.black.opacity(0.4))
                                            Image(systemName: "plus")
                                                .foregroundColor(mainDarkerColor)
                                                .font(.headline)
                                                .padding()
                                        }
                                    }
                                    .opacity((newDivisionName.isEmpty || newPeople.isEmpty) ? 0 : 1)
                                    .disabled(newDivisionName.isEmpty || newPeople.isEmpty)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                            Section {
                                Text("Other Divisions:")
                                    .font(.footnote.bold())
                                    .foregroundColor(.black)
                                ForEach(data.divisions) { division in   //cos sie pierdoliii - whitebox widmo po dodaniu
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                        Text(division.name)
                                            .padding()
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete { indices in
                                    data.divisions.remove(atOffsets: indices)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "mainCard", in: namespace)
                }
                RoundedRectangle(cornerRadius: 30)
                    .stroke(mainColor, lineWidth: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "mainCard", in: namespace)
            }
        }
    }
}

struct EditMultipleDivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        
        EditMultipleDivisionsView(data: .constant(MultipleDivisions.sampleData.multipleData), namespace: Namespace.init().wrappedValue)
        
    }
}
