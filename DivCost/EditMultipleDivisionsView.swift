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
    @State private var newDate: Date = Date()
    @State private var newTheme: Theme = .poppy
    
    var namespace: Namespace.ID
    
    let theme: Theme = .divcost
    
    init(data: Binding<MultipleDivisions.MultipleData>, namespace: Namespace.ID) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._data = data
        self.namespace = namespace
    }
    
    var body: some View {       //dodac wybor motywu
        VStack {
            Spacer()
            ZStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(theme.mainColor)
                        
                        List {
                            Section {
                                Text("New Division")
                                    .font(.footnote.bold())
                                    .foregroundColor(theme.textColor)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(UIColor.systemBackground))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    TextField("Division Name", text: $newDivisionName)
                                        .padding()
                                }
                                Text("New Theme")
                                    .font(.footnote.bold())
                                    .foregroundColor(theme.textColor)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(UIColor.systemBackground))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    ThemePickerView(selection: $newTheme)
                                }
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                Text("Date")
                                    .font(.footnote.bold())
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .foregroundColor(theme.textColor)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(UIColor.systemBackground))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    DatePickerView(date: $newDate, color: theme.mainColor)
                                        .padding()
                                }
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                
                                Text("New People")
                                    .font(.footnote.bold())
                                    .foregroundColor(theme.textColor)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(UIColor.systemBackground))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
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
                                            .fill(Color(UIColor.systemBackground))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                            }
                                        Text(person.name)
                                            .padding()
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                newPeople = Person.removePerson(people: newPeople, personID: person.id)
                                                //idk czy sie nie zjebie
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                                }
//                                .onDelete { indices in
//                                    newPeople.remove(atOffsets: indices)
//                                }
                                
                                
                                
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            data.divisions.append(Division(name: newDivisionName, people: newPeople, date: newDate, theme: newTheme))
                                        }
                                        newPerson = ""
                                        newDivisionName = ""
                                        withAnimation {
                                            newPeople.removeAll()
                                        }
                                    }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Material.thin)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Image(systemName: "plus")
                                                .foregroundColor(theme.textColor)
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
                                Text("Other Divisions")
                                    .font(.footnote.bold())
                                    .foregroundColor(theme.textColor)
                                ForEach(data.divisions) { division in   //cos sie pierdoliii - whitebox widmo po dodaniu
                                    Section {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Text(division.name)
                                                .padding()
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                data.removeDivision(divisionID: division.id)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                                    
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            Spacer(minLength: 100)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .modifier(ListBackgroundModifier())
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "mainCard", in: namespace)
                }
                RoundedRectangle(cornerRadius: 30)
                    .stroke(theme.mainColor, lineWidth: 20)
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
            .preferredColorScheme(.light)
        
        EditMultipleDivisionsView(data: .constant(MultipleDivisions.sampleData.multipleData), namespace: Namespace.init().wrappedValue)
            .preferredColorScheme(.dark)
    }
}
