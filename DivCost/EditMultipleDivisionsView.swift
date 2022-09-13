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
    
    @Namespace var namespace
    
    let mainColor = Color("MainColor")
    let mainDarkerColor = Color(UIColor(Color("MainColor")).darker())
    
    init(data: Binding<MultipleDivisions.MultipleData>) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._data = data
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(mainColor,mainDarkerColor)) // mozna jakis obrazek cool
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15, alignment: .center)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                Text("DivCost")
                    .padding(20)
                    .font(.system(size: 60).weight(.heavy))
                    .offset(x: 0, y: UIScreen.main.bounds.height*(-0.01))
            }
            .matchedGeometryEffect(id: "title", in: namespace)
            .fixedSize()
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(mainColor,mainDarkerColor))
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                    
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
                .listStyle(.plain)
            }
            .padding(.horizontal)
            .matchedGeometryEffect(id: "mainCard", in: namespace)
        }
    }
}

struct EditMultipleDivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        
            EditMultipleDivisionsView(data: .constant(MultipleDivisions.sampleData.multipleData))
        
    }
}
